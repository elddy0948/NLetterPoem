import Foundation
import Firebase

protocol DatabaseRequest: AnyObject {
  associatedtype ResultType
  
  var database: Firestore { get set }
  var reference: CollectionReference { get set }
  
  func create<T: Codable>(_ object: T, completed: @escaping (Result<ResultType, DatabaseError>) -> Void)
  func read(_ id: String, completed: @escaping (Result<ResultType, DatabaseError>) -> Void)
  func update<T: Codable>(_ object: T, completed: @escaping (Result<ResultType, DatabaseError>) -> Void)
  func delete(_ id: String, completed: @escaping (Error?) -> Void)
}
