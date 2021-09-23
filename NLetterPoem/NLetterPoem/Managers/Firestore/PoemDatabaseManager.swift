import Foundation
import Firebase
import FirebaseFirestoreSwift

final class PoemDatabaseManager: DatabaseRequest {
  //MARK: - Typealias
  typealias ResultType = NLPPoem
  typealias ErrorType = PoemFirestoreError
  
  //MARK: - Static
  static let shared = PoemDatabaseManager()
  
  //MARK: - Properties
  var database: Firestore = Firebase.Firestore.firestore()
  var reference: CollectionReference
  
  private init() {
    reference = database.collection("poems")
  }
  
  //MARK: - Database Request
  func create<T>(_ object: T,
                 completed: @escaping (Result<ResultType, ErrorType>) -> Void) where T : Decodable, T : Encodable {
    guard let poem = object as? NLPPoem else { return }
    
    let batch = database.batch()
    let poemRef = reference.document(poem.id)
    let userRef = database.collection("users").document(poem.authorEmail)
    
    do {
      try batch.setData(from: poem, forDocument: poemRef)
      batch.updateData([ "poems": FieldValue.arrayUnion([poem.id]) ], forDocument: userRef)
    } catch {
      completed(.failure(.failedCreatePoem))
    }
    
    batch.commit { error in
      if error != nil {
        completed(.failure(.failedCreatePoem))
      } else {
        completed(.success(poem))
      }
    }
  }
  
  func read(_ id: String,
            completed: @escaping (Result<ResultType, ErrorType>) -> Void) {
    let todayDate = Date().toYearMonthDay()
    let query = reference
      .whereField("authorEmail", isEqualTo: id)
      .whereField("createdAt", isEqualTo: todayDate)
    
    query.getDocuments { snapshot, error in
      guard let snapshot = snapshot,
            let document = snapshot.documents.first else {
        completed(.failure(.failedReadPoem))
        return
      }
      do {
        if let poem = try document.data(as: NLPPoem.self) {
          completed(.success(poem))
          return
        } else {
          completed(.failure(.failedReadPoem))
          return
        }
      } catch {
        completed(.failure(.failedReadPoem))
        return
      }
    }
  }
  
  func update<T: Codable>(_ object: T,
                          completed: @escaping (Result<ResultType, ErrorType>) -> Void) {
    guard let poem = object as? NLPPoem else { return }
    
    do {
      try reference.document(poem.id).setData(from: poem)
      completed(.success(poem))
      return
    } catch {
      completed(.failure(.failedUpdatePoem))
      return
    }
  }
  
  func delete(_ id: String,
              completed: @escaping (Error?) -> Void) {
    reference.document(id).delete { error in
      guard error == nil else {
        completed(ErrorType.failedDeletePoem)
        return
      }
      completed(nil)
    }
  }
  
  enum SortType {
    case like
    case recent
  }
}

//MARK: - Additional Requests
extension PoemDatabaseManager {
  func fetchTodayPoems(date: Date,
                       sortType: SortType,
                       completed: @escaping (Result<[ResultType], ErrorType>) -> Void) {
    let stringDate = date.toYearMonthDay()
    let query = reference.whereField("createdAt",isEqualTo: stringDate)
    var fetchedPoems = [NLPPoem]()
    
    query.getDocuments { snapshot, error in
      guard let querySnapshot = snapshot else {
        completed(.failure(.failedReadTodayPoems))
        return
      }
      
      for document in querySnapshot.documents {
        do {
          if let poem = try document.data(as: NLPPoem.self) {
            fetchedPoems.append(poem)
          }
        } catch {
          completed(.failure(.failedReadTodayPoems))
          return
        }
      }
      
      switch sortType {
      case .like:
        completed(.success(fetchedPoems.sorted { $0.likeCount > $1.likeCount }))
      case .recent:
        completed(.success(fetchedPoems.sorted { $0.created > $1.created }))
      }
    }
  }
  
  func fetchUserPoems(userEmail: String,
                      sortType: SortType,
                      completed: @escaping (Result<[ResultType], ErrorType>) -> Void) {
    let query = reference.whereField("authorEmail", isEqualTo: userEmail)
    var fetchedPoems = [NLPPoem]()
    
    query.getDocuments { snapshot, error in
      guard let querySnapshot = snapshot else {
        completed(.failure(.failedReadPoem))
        return
      }
      
      for document in querySnapshot.documents {
        do {
          if let poem = try document.data(as: NLPPoem.self) {
            fetchedPoems.append(poem)
          }
        } catch {
          completed(.failure(.failedReadPoem))
          return
        }
      }
      
      switch sortType {
      case .like:
        completed(.success(fetchedPoems.sorted { $0.likeCount > $1.likeCount }))
      case .recent:
        completed(.success(fetchedPoems.sorted { $0.created > $1.created }))
      }
    }
  }
  
  func updateLikeCount(poemID: String, author: String, isIncrease: Bool,
                       completed: @escaping (Error?) -> Void) {
    let count = isIncrease ? 1 : -1
    
    let batch = database.batch()
    
    let poemRef = reference.document(poemID)
    let userRef = database.collection("users").document(author)
    
    batch.updateData([ "likeCount": FieldValue.increment(Int64(count)) ], forDocument: poemRef)
    batch.updateData([ "fires": FieldValue.increment(Int64(count)) ], forDocument: userRef)
    
    batch.commit { error in
      if error != nil {
        completed(PoemFirestoreError.failedLike)
      } else {
        completed(nil)
      }
    }
  }
}
