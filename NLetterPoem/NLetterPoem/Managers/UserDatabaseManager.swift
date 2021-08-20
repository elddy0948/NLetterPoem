import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserDatabaseManager {
  
  //MARK: - Static
  static let shared = UserDatabaseManager()
  
  //MARK: - Properties
  private let database = Firebase.Firestore.firestore()
  private var userDatabaseQueue = DispatchQueue(label: "com.howift.userDB")
  private let userReference: CollectionReference
  
  private init() {
    userReference = database.collection("users")
  }
  
  //MARK: - User
  func createUser(with user: NLPUser, completed: @escaping (Error?) -> Void) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      do {
        try self.userReference.document(user.email).setData(from: user)
        completed(nil)
      } catch {
        completed(error)
        return
      }
    }
  }
  
  func updateUser(with user: NLPUser, completed: @escaping (Error?) -> Void) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      do {
        try self.userReference.document(user.email).setData(from: user, merge: true)
        completed(nil)
      } catch {
        completed(error)
      }
    }
  }
  
  func fetchUserInfo(with email: String, completed: @escaping (NLPUser?) -> Void) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      self.userReference.document(email).getDocument { document, error in
        let decoder = JSONDecoder()
        guard let data = document?.data() else {
          completed(nil)
          return
        }
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: data as Any)
          let user = try decoder.decode(NLPUser.self, from: jsonData)
          completed(user)
        } catch {
          completed(nil)
        }
      }
    }
  }
  
  func isUserExist(with email: String, completed: @escaping (Bool) -> Void) {
    userReference.document(email).getDocument { _, error in
      guard error == nil else {
        completed(false)
        return
      }
      completed(true)
    }
  }
  
  func fetchTopTenUsers(completed: @escaping ([NLPUser]) -> Void) {
    var topTenUsers = [NLPUser]()
    
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      
      self.userReference.order(by: "fires", descending: true).limit(to: 10).getDocuments { snapshot, error in
        guard let snapshot = snapshot else {
          completed(topTenUsers)
          return
        }
        
        let documents = snapshot.documents
        for document in documents {
          do {
            if let user = try document.data(as: NLPUser.self) {
              topTenUsers.append(user)
            }
          } catch {
            completed(topTenUsers)
            return
          }
        }
        
        completed(topTenUsers)
      }
    }
  }
  
  func addPoemToUser(email: String, poemID: String, completed: @escaping (Error?) -> Void) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      self.userReference.document(email).updateData([
        "poems": FieldValue.arrayUnion([poemID])
      ])
    }
  }
  
  func addLikedPoem(userEmail: String, poemID: String) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      self.userReference.document(userEmail).updateData([
        "likedPoem": FieldValue.arrayUnion([poemID])
      ])
    }
  }
  
  //MARK: - Delete
  func removeLikedPoem(userEmail: String, poemID: String) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      self.userReference.document(userEmail).updateData([
        "likedPoem": FieldValue.arrayRemove([poemID])
      ])
    }
  }
  
  func removePoem(userEmail: String, poemID: String) {
    userDatabaseQueue.async { [weak self] in
      guard let self = self else { return }
      self.userReference.document(userEmail).updateData([
        "poems": FieldValue.arrayRemove([poemID])
      ])
    }
  }
  
  func deleteUserOnAuth(email: String,
                        completed: @escaping ((Result<String, UserDatabaseError>) -> Void)) {
    guard let user = Auth.auth().currentUser else {
      completed(.failure(.noAuthority))
      return
    }
    
    DispatchQueue.global(qos: .utility).async {
      user.delete { error in
        if let _ = error {
          completed(.failure(.failedToDelete))
          return
        }
        completed(.success("삭제에 성공했습니다!"))
      }
    }
  }
  
  func deleteUserOnFirestore(email: String,
                             completed: @escaping ((Result<String, UserDatabaseError>) -> Void)) {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else {
        completed(.failure(.failedToDelete))
        return
      }
      
      self.userReference.document(email).delete { error in
        if let _  = error {
          completed(.failure(.failedToDelete))
          return
        }
        completed(.success("삭제에 성공했습니다!"))
        return
      }
    }
  }
}
