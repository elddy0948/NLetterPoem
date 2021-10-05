import FirebaseFirestore
import RxSwift


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
}
