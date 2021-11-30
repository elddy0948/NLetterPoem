import RxSwift
import Firebase

final class TodayViewModel {
  
  private let firestore = Firestore.firestore()
  //Topic
  func fetchTodayTopic(_ date: Date) -> Observable<NLPTopic> {
    let stringDate = date.toYearMonthDay()
    
    return firestore.collection("topics")
      .document("test")
      .rx
      .getDocument()
      .take(1)
      .map({ snapshot -> NLPTopic in
        do {
          let topic = try snapshot.data(as: NLPTopic.self) ?? NLPTopic(topic: "")
          return topic
        } catch {
          return NLPTopic(topic: "")
        }
      })
  }
  
  //Today Poems
  func fetchTodayPoems(_ date: Date) -> Observable<[NLPPoem]> {
    let stringDate = date.toYearMonthDay()
    
    return firestore.collection("poems")
      .whereField("createdAt", isEqualTo: stringDate)
      .rx
      .getDocuments()
      .take(1)
      .map({ snapshot in
        guard let document = snapshot.documents.first else { return [] }
        
        do {
          let poems = try document.data(as: [NLPPoem].self) ?? []
          return poems.sorted(by: { $0.created > $1.created })
        } catch {
          return []
        }
      })
  }
}
