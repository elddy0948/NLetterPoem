import FirebaseAuth
import RxSwift

extension Reactive where Base: Auth {
  public func configureStateChangeListener() -> Observable<User> {
    return Observable.create({ observer in
      let handler = self.base.addStateDidChangeListener { auth, user in
        if let user = user {
          observer.onNext(user)
        } else {
          observer.onError(AuthError.userMissing)
        }
      }
      return Disposables.create {
        print("Disposed!")
        self.base.removeStateDidChangeListener(handler)
      }
    })
  }
}
