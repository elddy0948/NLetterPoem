import Foundation
import RxSwift
import FirebaseFirestore


extension Reactive where Base: DocumentReference {
  public func getDocument() -> Observable<DocumentSnapshot> {
    return Observable.create({ observer in
      self.base.getDocument { documentSnapshot, error in
        if let error = error {
          observer.onError(error)
        } else if let documentSnapshot = documentSnapshot,
                  documentSnapshot.exists {
          observer.onNext(documentSnapshot)
          observer.onCompleted()
        } else {
          observer.onError(DocumentError.documentNotFound)
        }
      }
      return Disposables.create { }
    })
  }
  
  func setData<T: Encodable>(_ data: T) -> Completable {
    return Completable.create(subscribe: { completable in
      do {
        try base.setData(from: data)
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
}
