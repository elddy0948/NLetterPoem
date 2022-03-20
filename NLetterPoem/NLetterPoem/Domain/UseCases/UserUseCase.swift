import Foundation
import RxSwift

public protocol UserUseCase {
  func read(_ email: String) -> Observable<NLetterPoemUser>
  func delete(_ user: NLetterPoemUser) -> Observable<Void>
  func update(_ user: NLetterPoemUser) -> Observable<Void>
  func create(_ user: NLetterPoemUser) -> Observable<Void>
}
