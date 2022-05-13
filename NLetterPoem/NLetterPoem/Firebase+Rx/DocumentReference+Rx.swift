import Foundation
import RxSwift
import Firebase
import FirebaseFirestore

extension Reactive where Base: DocumentReference {
  
  func getDocument() -> Observable<DocumentSnapshot> {
    return Observable.create { observer in
      self.base.getDocument { snapshot, error in
        if let error = error {
          observer.onError(error)
        } else if let snapshot = snapshot, snapshot.exists {
          observer.onNext(snapshot)
          observer.onCompleted()
        } else {
          observer.onError(DocumentError.documentNotFound)
        }
      }
      return Disposables.create()
    }
  }
  
  func setData<T: Encodable>(_ data: T) -> Completable {
    return Completable.create(subscribe: { completable in
      do {
        //        try base.setData(from: data)
        completable(.completed)
      } catch {
        completable(.error(error))
      }
      return Disposables.create { }
    })
  }
  
  func delete() -> Completable {
    return Completable.create(subscribe: { completable in
      base.delete(completion: { error in
        guard let error = error else {
          completable(.completed)
          return
        }
        
        completable(.error(error))
      })
      
      return Disposables.create {}
    })
  }
  
  func listen() -> Observable<DocumentSnapshot> {
    return Observable<DocumentSnapshot>.create { observer in
      let listener = self.base.addSnapshotListener() { snapshot, error in
        if let error = error {
          observer.onError(error)
        } else if let snapshot = snapshot {
          observer.onNext(snapshot)
        }
      }
      return Disposables.create {
        listener.remove()
      }
    }
  }
}
