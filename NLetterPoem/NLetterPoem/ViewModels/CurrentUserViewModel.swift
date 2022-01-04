import Foundation
import RxSwift

final class CurrentUserViewModel {
  static let shared = CurrentUserViewModel()
  
  let userSubject = BehaviorSubject<NLPUser>(value: .empty)
  
  private let service = FirestoreUserApi.shared
  private let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: DispatchQueue.global()
  )
  private let bag = DisposeBag()
  
  private init() { }
  
  func fetchCurrentUser(_ email: String) {
    service.read(email)
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onSuccess: { [weak self] user in
          guard let self = self,
                let user = user else { return }
          self.userSubject.onNext(user)
        },
        onFailure: { error in },
        onDisposed: {}
      )
      .disposed(by: bag)
  }
  
  func configureStateChangeListener() {
    
  }
  
  //TODO: - Check User did write poem today
}

extension CurrentUserViewModel {
  var user: NLPUser {
    do {
      return try userSubject.value()
    } catch {
      return .empty
    }
  }
  
  var email: String {
    return user.email
  }
  
  var nickname: String {
    return user.nickname
  }
  
  var bio: String {
    return user.bio
  }
  
  var fires: Int {
    return user.fires
  }
  
  var likedPoems: [String] {
    return user.likedPoem
  }
  
  var blockedUser: [String] {
    return user.blockedUser
  }
  
  var poems: [String] {
    return user.poems
  }
}
