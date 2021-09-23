import Foundation
import Firebase
import FirebaseFirestoreSwift

final class UserDatabaseManager: DatabaseRequest {
  //MARK: - Typealias
  typealias ResultType = NLPUser
  typealias ErrorType = UserFirestoreError
  
  //MARK: - Static
  static let shared = UserDatabaseManager()
  
  //MARK: - Properties
  var database: Firestore = Firebase.Firestore.firestore()
  var reference: CollectionReference
  
  private init() {
    reference = database.collection("users")
  }
  
  //MARK: - DatabaseRequest
  func create<T>(_ object: T, completed: @escaping (Result<ResultType, ErrorType>) -> Void) where T: Codable {
    guard let user = object as? NLPUser else {
      completed(.failure(.failedCreateUser))
      return
    }
    
    do {
      try reference.document(user.email).setData(from: object)
      completed(.success(user))
    } catch {
      completed(.failure(.failedCreateUser))
      return
    }
  }
  
  func read(_ id: String, completed: @escaping (Result<ResultType, ErrorType>) -> Void) {
    reference.document(id).getDocument { document, error in
      let decoder = JSONDecoder()
      guard let data = document?.data() else {
        completed(.failure(.failedReadUser))
        return
      }
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: data as Any)
        let user = try decoder.decode(NLPUser.self, from: jsonData)
        completed(.success(user))
      } catch {
        completed(.failure(.failedReadUser))
      }
    }
  }
  
  func update<T>(_ object: T, completed: @escaping (Result<ResultType, ErrorType>) -> Void) where T : Decodable, T : Encodable {
    guard let user = object as? NLPUser else {
      completed(.failure(.failedUpdateUser))
      return
    }
    
    do {
      try reference.document(user.email).setData(from: object, merge: true)
      completed(.success(user))
    } catch {
      completed(.failure(.failedUpdateUser))
      return
    }
  }
  
  func delete(_ id: String, completed: @escaping (Error?) -> Void) {
    reference.document(id).delete { error in
      if let error  = error {
        completed(error)
        return
      }
      completed(nil)
      return
    }
  }
}

//MARK: - Additional Request
extension UserDatabaseManager {
  func fetchTopTenUsers(completed: @escaping (Result<[ResultType], ErrorType>) -> Void) {
    var topTenUsers = [NLPUser]()
    
    reference.order(by: "fires", descending: true)
      .limit(to: 10)
      .getDocuments { snapshot, error in
        guard let snapshot = snapshot else {
          completed(.failure(.failedToFetchTopTenUsers))
          return
        }
        
        let documents = snapshot.documents
        
        _ = documents.map { document in
          do {
            if let user = try document.data(as: NLPUser.self) {
              topTenUsers.append(user)
            }
          } catch {
            completed(.failure(.failedToFetchTopTenUsers))
            return
          }
        }
        
        completed(.success(topTenUsers))
      }
  }
  
  func likedPoem(to userEmail: String, poemID: String, completed: @escaping (Result<String, ErrorType>) -> Void) {
    reference.document(userEmail).updateData([
      "likedPoem": FieldValue.arrayUnion([poemID])
    ])
  }
  
  func deletePoem(to userEmail: String, poemID: String, completed: @escaping (Result<String, ErrorType>) -> Void) {
    reference.document(userEmail).updateData([
      "poems": FieldValue.arrayRemove([poemID])
    ]) { error in
      if error != nil {
        completed(.failure(.failedDeletePoemFromUser))
      }
      completed(.success("삭제에 성공했습니다!"))
    }
  }
  
  func unLikedPoem(to userEmail: String, poemID: String, completed: @escaping (Result<String, ErrorType>) -> Void) {
    reference.document(userEmail).updateData([
      "likedPoem": FieldValue.arrayRemove([poemID])
    ]) { error in
      if error != nil {
        completed(.failure(.failedUnlikePoem))
        return
      }
      completed(.success("좋아요가 취소되었습니다."))
    }
  }
}
