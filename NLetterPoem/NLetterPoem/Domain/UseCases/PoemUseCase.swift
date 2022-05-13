import Foundation
import RxSwift

public protocol PoemUseCase {
  func create(_ poem: Poem) -> Completable
  func update(_ poem: Poem) -> Completable
  func delete(_ poem: Poem) -> Completable
  func readPoem(_ id: String) -> Observable<Poem>
  func readPoems(query: PoemQuery) -> Observable<[Poem]>
  func readPoems(
    query: NLetterQuery?, by order: String, limit: Int
  ) -> Observable<(NLetterQuery?, [Poem])>
}
