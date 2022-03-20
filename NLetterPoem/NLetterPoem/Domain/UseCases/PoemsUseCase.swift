import Foundation
import RxSwift

public protocol PoemsUseCase {
  func create(_ poem: NLetterPoem) -> Observable<Void>
  func update(_ poem: NLetterPoem) -> Observable<NLetterPoem>
  func delete(_ poem: NLetterPoem) -> Observable<Void>
  func read() -> Observable<[NLetterPoem]>
}
