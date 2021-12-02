import Foundation
import RxSwift
import FirebaseFirestore


class SearchViewModel {
  
  private let reference = Firestore.firestore().collection("poems")
  
  func search(topic: String) -> Observable<[PoemViewModel]> {
    reference.whereField("topic", isEqualTo: topic).rx
      .getDocuments().map({ querySnapshot in
        querySnapshot.documents.map({ document in
          do {
            let poem = try document.data(as: NLPPoem.self)
            let poemViewModel = PoemViewModel(
              poem ?? .emptyPoem()
            )
            return poemViewModel
          } catch {
            return PoemViewModel(.emptyPoem())
          }
        })
      })
  }
}
