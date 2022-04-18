import Foundation
import RxSwift
import FirebaseFirestore

final class UserCollection {
  private let network: FirestoreNetwork<UserDTO>
  
  init(_ network: FirestoreNetwork<UserDTO>) {
    self.network = network
  }
  
  public func createUser(_ user: UserDTO) -> Completable {
    return network.create(itemId: user.email, item: user)
  }
  
  public func readUser(_ email: String) -> Observable<UserDTO> {
    return network.getItem(email)
  }
  
  public func readUsers(_ query: UserQuery) -> Observable<[UserDTO]> {
    return network.getItems(query, queryType: .user)
  }
  
  public func updateUser(_ user: UserDTO) -> Completable {
    return network.update(user.email, item: user)
  }
  
  public func deleteUser(_ user: UserDTO) -> Completable {
    return network.delete(user.email)
  }
}
