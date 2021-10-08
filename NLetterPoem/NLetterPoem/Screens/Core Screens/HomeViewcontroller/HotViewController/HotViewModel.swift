import UIKit
import FirebaseFirestore
import RxSwift

class HotViewModel {
  //Poems
  
  private let reference = Firestore.firestore()
  
  //Fetch Poems top *30*?
  func fetchHotPoems() -> Observable<[HotPoemViewModel]> {
    reference.collection("poems")
      .order(by: "likeCount", descending: true)
      .limit(to: 30).rx.getDocuments().map({ querySnapshot in
        querySnapshot.documents.map({ document in
          do {
            if let poem = try document.data(as: NLPPoem.self) {
              return HotPoemViewModel(poem: poem)
            } else { return HotPoemViewModel(poem: .emptyPoem()) }
          } catch {
            return HotPoemViewModel(poem: .emptyPoem())
          }
        })
      })
  }
}
