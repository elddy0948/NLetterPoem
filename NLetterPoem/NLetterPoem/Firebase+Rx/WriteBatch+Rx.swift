import RxSwift
import FirebaseFirestore

extension Reactive where Base: WriteBatch {
  func commit() -> Completable {
    return Completable.create(subscribe: { completable in
      self.base.commit(completion: { error in
        guard let error = error else {
          completable(.completed)
          return
        }
        completable(.error(error))
      })
      return Disposables.create { }
    })
  }
}
