import Foundation
import RxSwift
import FirebaseFirestore


class SearchViewModel {
  
  private let reference = Firestore.firestore().collection("poems")
  
  func search(topic: String) -> Observable<[NLPPoem]> {
    reference.whereField("topic", isEqualTo: topic).rx
      .getDocuments().map({ querySnapshot in
        querySnapshot.documents.map({ document in
          do {
            let poem = try document.data(as: NLPPoem.self)
            return poem ?? .emptyPoem()
          } catch {
            return .emptyPoem()
          }
        })
      })
  }
}
