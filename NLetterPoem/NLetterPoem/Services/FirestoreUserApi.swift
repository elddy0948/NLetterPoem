import Foundation
import FirebaseFirestore
import RxSwift

final class FirestoreUserApi: FirestoreService {
  enum UserServiceError: Error {
    case invalidUser
    case invalidRequest
  }
  
  static let shared = FirestoreUserApi()
  
  var database: Firestore = Firestore.firestore()
  var reference: CollectionReference
  
  private init() {
    reference = database.collection("users")
  }
  
  func create<T: Encodable>(_ object: T) -> Completable {
    guard let user = object as? NLPUser else {
      return Completable.error(UserServiceError.invalidUser)
    }
    
    return reference.document(user.email)
      .rx
      .setData(user)
  }
  
  func read(_ id: String) -> Single<NLPUser?> {
    return reference.document(id)
      .rx
      .getDocument()
      .map({ document in
        if let user = try document.data(as: NLPUser.self) {
          return user
        }
        return nil
      })
      .asSingle()
  }
  
  func update<T: Encodable>(_ object: T) -> Completable {
    guard let user = object as? NLPUser else {
      return Completable.error(UserServiceError.invalidUser)
    }
    
    return reference.document(user.email)
      .rx
      .setData(user)
  }
  
  func delete(_ id: String) -> Completable {
    return reference.document(id)
      .rx
      .delete()
  }
}

