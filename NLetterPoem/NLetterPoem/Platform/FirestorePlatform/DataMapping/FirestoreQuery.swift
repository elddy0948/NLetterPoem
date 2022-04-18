import Foundation
import Firebase
import FirebaseFirestore

final class FirestoreQuery {
  let query: NLetterQuery
  let reference: CollectionReference
  
  init(_ query: NLetterQuery, reference: CollectionReference) {
    self.query = query
    self.reference = reference
  }
  
  func toUserQuery() -> Query? {
    guard let userQuery = query as? UserQuery else {
      return nil
    }
    
    let resultQuery: Query = reference
    
    return resultQuery
  }
  
  func toPoemQuery() -> Query? {
    guard let poemQuery = query as? PoemQuery else {
      return nil
    }
    
    if let authorEmail = poemQuery.authorEmail {
      return reference.whereField("authorEmail", isEqualTo: authorEmail)
    }
    
    return nil
  }
}
