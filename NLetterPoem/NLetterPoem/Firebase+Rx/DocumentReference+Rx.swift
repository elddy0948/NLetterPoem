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
  
  public func setData<T: Encodable>(_ data: T) -> Observable<Void> {
    return Observable.create({ observer in
      do {
        try self.base.setData(from: data)
        observer.onNext(())
        observer.onCompleted()
      } catch let error {
        observer.onError(error)
      }
      return Disposables.create { }
    })
  }
  
  public func delete() -> Observable<Void> {
    return Observable.create({ observer in
      self.base.delete(completion: { error in
        guard let error = error else {
          observer.onNext(())
          observer.onCompleted()
          return
        }
        observer.onError(error)
      })
      return Disposables.create {}
    })
  }
}
