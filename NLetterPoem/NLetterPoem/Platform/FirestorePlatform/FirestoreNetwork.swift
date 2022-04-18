import Foundation
import FirebaseFirestore
import Firebase
import RxSwift

final class FirestoreNetwork<T: Codable> {
  enum QueryType {
    case poem
    case user
  }
  
  private let reference: CollectionReference
  private let scheduler: ConcurrentDispatchQueueScheduler
  
  init(_ reference: CollectionReference) {
    self.reference = reference
    self.scheduler = ConcurrentDispatchQueueScheduler(
      qos: .background
    )
  }
  
  func getItem(_ itemId: String) -> Observable<T> {
    return reference.document(itemId)
      .rx
      .getDocument()
      .observe(on: scheduler)
      .compactMap({ snapshot -> T? in
        return try snapshot.data(as: T.self)
      })
  }
  
  func getItems(_ query: NLetterQuery, queryType: QueryType) -> Observable<[T]> {
    let firestoreQuery = FirestoreQuery(query, reference: reference)
    let queryToRequest: Query?
    
    switch queryType {
    case .poem:
      queryToRequest = firestoreQuery.toPoemQuery()
    case .user:
      queryToRequest = firestoreQuery.toUserQuery()
    }
    
    guard let queryToRequest = queryToRequest else {
      return Observable.just([])
    }

    return queryToRequest
      .rx
      .getDocuments()
      .observe(on: scheduler)
      .map({ snapshot -> [T] in
        return snapshot.documents.compactMap({ document -> T? in
          return try? document.data(as: T.self)
        })
      })
  }
  
  func update(_ itemId: String, item: T) -> Completable {
    return reference.document(itemId)
      .rx
      .setData(item)
  }
  
  func delete(_ itemId: String) -> Completable {
    return reference.document(itemId)
      .rx
      .delete()
  }
  
  func create(itemId: String, item: T) -> Completable {
    return reference.document(itemId).rx
      .setData(item)
  }
}
