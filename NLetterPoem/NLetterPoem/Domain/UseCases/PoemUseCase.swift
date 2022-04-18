import Foundation
import RxSwift

public protocol PoemUseCase {
  func create(_ poem: NLetterPoem) -> Completable
  func update(_ poem: NLetterPoem) -> Completable
  func delete(_ poem: NLetterPoem) -> Completable
  func readPoem(_ id: String) -> Observable<NLetterPoem>
  func readPoems(query: PoemQuery) -> Observable<[NLetterPoem]>
}
