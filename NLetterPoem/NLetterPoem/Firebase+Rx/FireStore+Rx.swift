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

extension Reactive where Base: Query {
  public func getDocuments() -> Observable<QuerySnapshot> {
    return Observable.create({ observer in
      self.base.getDocuments(completion: { querySnapshot, error in
        if let error = error {
          print("===========Error============")
          observer.onError(error)
        } else if let querySnapshot = querySnapshot {
          observer.onNext(querySnapshot)
          observer.onCompleted()
        } else {
          observer.onError(DocumentError.documentNotFound)
        }
      })
      return Disposables.create { }
    })
  }
}
