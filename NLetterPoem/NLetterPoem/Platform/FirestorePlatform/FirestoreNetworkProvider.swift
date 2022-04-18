import Foundation
import Firebase
import FirebaseFirestore
import RxSwift

final class FirestoreNetworkProvider {
  private let firestore: Firestore
  
  public init() {
    firestore = Firestore.firestore()
  }
  
  func makePoemCollection() -> PoemCollection {
    let network = FirestoreNetwork<PoemDTO>(firestore.collection("poems"))
    return PoemCollection(network: network)
  }
  
  func makeUserCollection() -> UserCollection {
    let network = FirestoreNetwork<UserDTO>(firestore.collection("users"))
    return UserCollection(network)
  }
  
  func makeTopicCollection() -> TopicCollection {
    let network = FirestoreNetwork<TopicDTO>(firestore.collection("topics"))
    return TopicCollection(network)
  }
}
