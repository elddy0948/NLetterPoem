import Foundation
import RxSwift

final class TopicCollection {
  private let network: FirestoreNetwork<TopicDTO>
  
  init(_ network: FirestoreNetwork<TopicDTO>) {
    self.network = network
  }
  
  public func readTopic(_ date: String) -> Observable<TopicDTO> {
    return network.getItem(date)
  }
}
