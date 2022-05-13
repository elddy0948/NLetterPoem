import Firebase
import RxSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    reference.document(itemId)
      .rx
      .getDocument()
      .map({ snapshot -> T in
        try snapshot.data(as: T.self)
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
  
  func getItems(query: NLetterQuery?, order: String, limit: Int) -> Observable<(NLetterQuery?, [T])> {
    let firQuery: Query?
    
    if let query = query {
      firQuery = query as? Query
    } else {
      firQuery = reference
        .order(by: order, descending: true)
        .limit(to: limit)
    }
    
    guard let firQuery = firQuery else {
      return Observable.just((nil, []))
    }

    
    return firQuery.rx.listen()
      .observe(on: scheduler)
      .map({ snapshot -> (Query?, [T]) in
        guard let lastSnapshot = snapshot.documents.last else {
          return (nil, [])
        }
        
        let next = self.reference
          .order(by: order, descending: true)
          .limit(to: limit)
          .start(afterDocument: lastSnapshot)
        
        let results = snapshot.documents.compactMap({ document -> T? in
          return try? document.data(as: T.self)
        })
        
        return (next, results)
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

extension Query: NLetterQuery { }
