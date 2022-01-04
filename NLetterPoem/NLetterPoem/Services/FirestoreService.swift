import Firebase
import FirebaseFirestore
import RxSwift

protocol FirestoreService: AnyObject {
  associatedtype ResultType
  
  var database: Firestore { get set }
  var reference: CollectionReference { get set }
  
  //CRUD
  func create<T: Encodable>(_ object: T) -> Completable
  func read(_ id: String) -> Single<ResultType>
  func update<T: Encodable>(_ object: T) -> Completable
  func delete(_ id: String) -> Completable
}
