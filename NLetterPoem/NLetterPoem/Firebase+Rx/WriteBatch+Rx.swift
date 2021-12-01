import RxSwift
import FirebaseFirestore

extension Reactive where Base: WriteBatch {
  func commit() -> Observable<Void> {
    return Observable.create({ observer in
      self.base.commit(completion: { error in
        guard let error = error else {
          //If Error not occured
          observer.onNext(())
          observer.onCompleted()
          return
        }
        
        //If Error occured
        observer.onError(error)
      })
      return Disposables.create { }
    })
  }
}
