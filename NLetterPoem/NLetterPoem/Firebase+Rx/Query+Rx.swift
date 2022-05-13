//
//  Query+Rx.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/01.
//

import RxSwift
import FirebaseFirestore

extension Reactive where Base: Query {
  func getDocuments() -> Observable<QuerySnapshot> {
    return Observable.create({ observer in
      self.base.getDocuments(completion: { querySnapshot, error in
        if let error = error {
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
  
  func listen() -> Observable<QuerySnapshot> {
    return Observable<QuerySnapshot>.create { observer in
      let listener = self.base.addSnapshotListener { snapshot, error in
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
