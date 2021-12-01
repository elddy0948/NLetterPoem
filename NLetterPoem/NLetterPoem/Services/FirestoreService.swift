import Firebase
import FirebaseFirestore
import RxSwift

protocol FirestoreService: AnyObject {
  associatedtype ResultType
  
  var database: Firestore { get set }
  var reference: CollectionReference { get set }
  
  //CRUD
  func create<T: Encodable>(_ object: T) -> Observable<Void>
  func read(_ id: String) -> Observable<ResultType>
  func update<T: Encodable>(_ object: T) -> Observable<Void>
  func delete(_ id: String) -> Observable<Void>
}
