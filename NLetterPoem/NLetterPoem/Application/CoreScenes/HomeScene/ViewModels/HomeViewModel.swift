import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
  struct Input {
    let currentUserEmail: Observable<String>
  }
  
  struct Output {
    let user: Driver<NLetterPoemUser>
  }
  
  private let usecase = FirestoreUsecaseProvider().makeUserUseCase()
  
  func transform(input: Input) -> Output {
    let user = input.currentUserEmail
      .flatMapLatest({ email in
        return self.usecase.read(email)
      })
      .asDriver(onErrorJustReturn: NLetterPoemUser(email: "", nickname: "", bio: ""))
    
    return Output(user: user)
  }
}