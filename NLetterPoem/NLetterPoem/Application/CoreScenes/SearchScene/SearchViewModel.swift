import Foundation
import RxSwift
import Firebase
import FirebaseFirestoreSwift


class SearchViewModel {
  
  private let reference = Firestore.firestore().collection("poems")
  
  func search(topic: String) -> Observable<[Poem]> {
    reference.whereField("topic", isEqualTo: topic).rx
      .getDocuments().map({ querySnapshot in
        querySnapshot.documents.map({ document in
          do {
            let poem = try document.data(as: Poem.self)
            return poem
          } catch {
            return Poem.empty
          }
        })
      })
  }
}
