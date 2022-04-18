import Foundation
import RxSwift

public protocol UserUseCase {
  func read(_ email: String) -> Observable<NLetterPoemUser>
  func delete(_ user: NLetterPoemUser) -> Completable
  func update(_ user: NLetterPoemUser) -> Completable
  func create(_ user: NLetterPoemUser) -> Completable
  func readUsers(_ query: UserQuery) -> Observable<[NLetterPoemUser]>
}
