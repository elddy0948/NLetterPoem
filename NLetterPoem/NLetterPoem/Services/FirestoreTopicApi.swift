import Foundation
import RxSwift
import Firebase


final class FirestoreTopicApi {
  static let shared = FirestoreTopicApi()
  
  private let firestore = Firestore.firestore()
  
  private init() { }
  
  func fetchTopic(_ date: Date) -> Observable<NLPTopic> {
    return firestore.collection("topics")
      .document("test")
      .rx
      .getDocument()
      .take(1)
      .map({ snapshot -> NLPTopic in
        do {
          let topic = try snapshot.data(
            as: NLPTopic.self
          ) ?? NLPTopic(topic: "")
          return topic
        } catch {
          return NLPTopic(topic: "")
        }
      })
  }
}
