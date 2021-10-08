import Foundation
import Firebase
import FirebaseFirestore

final class ReportDatabaseManager {
  
  static let shared = ReportDatabaseManager()
  
  var database: Firestore = Firestore.firestore()
  var reference: CollectionReference
  
  private init() {
    reference = database.collection("reports")
  }
  
  func create(user: String, reportedPoem: NLPPoem, reportMessage: String, completed: @escaping (Result<String, ReportError>) -> Void) {
    let documentID = "\(user)REP\(reportedPoem.id)"
    reference.document(documentID).setData([
      "reportedPoem": reportedPoem.id,
      "reportMessage": reportMessage,
      "reportUser": user,
    ]) { error in
      if error != nil {
        completed(.failure(.failedReport))
        return
      } else {
        completed(.success("신고가 접수되었습니다!"))
      }
    }
  }
}
