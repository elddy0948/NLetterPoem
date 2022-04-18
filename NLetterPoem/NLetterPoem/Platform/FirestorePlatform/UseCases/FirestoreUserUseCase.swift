import Foundation
import RxSwift

final class FirestoreUserUseCase: UserUseCase {
  private let collection: UserCollection
  
  init(collection: UserCollection) {
    self.collection = collection
  }
  
  func read(_ email: String) -> Observable<NLetterPoemUser> {
    return collection.readUser(email)
      .map({ $0.toDomain() })
  }
  
  func delete(_ user: NLetterPoemUser) -> Completable {
    let userDTO = UserDTO(user)
    return collection.deleteUser(userDTO)
  }
  
  func update(_ user: NLetterPoemUser) -> Completable {
    let userDTO = UserDTO(user)
    return collection.updateUser(userDTO)
  }
  
  func create(_ user: NLetterPoemUser) -> Completable {
    let userDTO = UserDTO(user)
    return collection.createUser(userDTO)
  }
  
  func readUsers(_ query: UserQuery) -> Observable<[NLetterPoemUser]> {
    return collection.readUsers(query)
      .map({ $0.map({ $0.toDomain() }) })
  }
}
