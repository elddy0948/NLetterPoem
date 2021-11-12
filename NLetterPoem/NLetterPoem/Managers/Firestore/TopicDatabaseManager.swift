import Firebase
import FirebaseFirestoreSwift

final class ToopicDatabaseManager {
  static let shared = ToopicDatabaseManager()
  
  private let database = Firestore.firestore()
  private let reference: CollectionReference
  
  private init() {
    reference = database.collection("topics")
  }
  
  func read(date: Date, completed: @escaping (Result<String, TopicFirestoreError>) -> Void) {
    let stringDate = date.toYearMonthDay()
    reference.document(stringDate).getDocument { document, error in
      guard let document = document else {
        completed(.failure(.failedReadTopic))
        return
      }
      
      do {
        if let data = try document.data(as: NLPTopic.self) {
          DispatchQueue.global(qos: .utility).async {
            completed(.success(data.topic))
            return
          }
        }
        completed(.success(""))
      } catch {
        completed(.failure(.failedReadTopic))
        return
      }
    }
  }
}
