import Foundation
import Firebase

protocol DatabaseRequest: AnyObject {
  associatedtype ResultType
  associatedtype ErrorType: Error
  
  var database: Firestore { get set }
  var reference: CollectionReference { get set }
  
  func create<T: Codable>(_ object: T, completed: @escaping (Result<ResultType, ErrorType>) -> Void)
  func read(_ id: String, completed: @escaping (Result<ResultType, ErrorType>) -> Void)
  func update<T: Codable>(_ object: T, completed: @escaping (Result<ResultType, ErrorType>) -> Void)
  func delete(_ id: String, completed: @escaping (Error?) -> Void)
}
