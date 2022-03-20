import Foundation
import RxSwift

public protocol TopicUseCase {
  func read() -> Observable<NLetterTopic>
}
