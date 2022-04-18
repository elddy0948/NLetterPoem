import Foundation
import RxSwift

final class FirestoreTopicUseCase: TopicUseCase {
  private let collection: TopicCollection
  
  init(collection: TopicCollection) {
    self.collection = collection
  }
  
  func read() -> Observable<NLetterTopic> {
    return collection.readTopic(Date().toYearMonthDay())
      .map({ $0.toDomain() })
  }
}
