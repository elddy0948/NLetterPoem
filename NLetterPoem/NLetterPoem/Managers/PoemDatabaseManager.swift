import Foundation
import Firebase
import FirebaseFirestoreSwift

final class PoemDatabaseManager: DatabaseRequest {
  
  typealias ResultType = NLPPoem
  
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
                 completed: @escaping (Result<NLPPoem, DatabaseError>) -> Void) where T : Decodable, T : Encodable {
    guard let poem = object as? NLPPoem else { return }
    do {
      try reference.document(poem.id).setData(from: poem)
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  func read(_ id: String,
            completed: @escaping (Result<NLPPoem, DatabaseError>) -> Void) {
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
                          completed: @escaping (Result<NLPPoem, DatabaseError>) -> Void) {
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
        completed(DatabaseError.failedDeletePoem)
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
                       completed: @escaping (Result<[NLPPoem], DatabaseError>) -> Void) {
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
                      completed: @escaping (Result<[NLPPoem], DatabaseError>) -> Void) {
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
  
  func updateLikeCount(poemID: String, isIncrease: Bool) {
    let count = isIncrease ? 1 : -1
    
    reference.document(poemID).updateData([
      "likeCount": FieldValue.increment(Int64(count))
    ])
  }
}
