import Foundation
import RxSwift
import Firebase

final class FirestorePoemService: FirestoreService {
  enum PoemServiceError: String, Error {
    case invalidPoem = "시의 형식을 확인해 주세요!"
    case invalidRequest = "다시 시도해 주세요!"
  }
  
  static let shared = FirestorePoemService()
  
  typealias ResultType = NLPPoem
  
  //MARK: - Properties
  var database = Firestore.firestore()
  var reference: CollectionReference
  
  //MARK: - Initializer
  private init() {
    reference = database.collection("poems")
  }
  
  func create<T: Encodable>(_ object: T) -> Observable<Void> {
    guard let poem = object as? NLPPoem else {
      return Observable.error(PoemServiceError.invalidPoem)
    }
    
    let batch = database.batch()
    let poemDocument = reference.document(poem.id)
    let userDocument = database
      .collection("users")
      .document(poem.authorEmail)
    
    do {
      try batch.setData(from: poem,
                        forDocument: poemDocument)
      batch.updateData([
        "poems": FieldValue.arrayUnion([poem.id])
      ], forDocument: userDocument)
    } catch {
      return Observable.error(PoemServiceError.invalidRequest)
    }
    
    return batch.rx.commit()
  }
  
  func read(_ id: String) -> Observable<NLPPoem> {
    let todayDate = Date().toYearMonthDay()
    let query = reference
      .whereField("authorEmail", isEqualTo: id)
      .whereField("createdAt", isEqualTo: todayDate)
    
    return query.rx
      .getDocuments()
      .map({ snapshot in
        guard let document = snapshot.documents.first else {
          return NLPPoem.emptyPoem()
        }
        if let poem = try document.data(as: NLPPoem.self) {
          return poem
        }
        return NLPPoem.emptyPoem()
      })
  }
  
  func update<T: Encodable>(_ object: T) -> Observable<Void>{
    guard let poem = object as? NLPPoem else {
      return Observable.error(PoemServiceError.invalidPoem)
    }
    
    return reference.document(poem.id)
      .rx
      .setData(poem)
  }
  
  func delete(_ id: String) -> Observable<Void> {
    return reference.document(id)
      .rx
      .delete()
  }
}

extension FirestorePoemService {
  //Fetch today poems
  func fetchPoems(query: (field: String, value: String)) -> Observable<[ResultType]> {
    var fetchedResult = [ResultType]()
    return reference
      .whereField(query.field, isEqualTo: query.value)
      .rx
      .getDocuments()
      .map({ querySnapshot in
        querySnapshot.documents.forEach({ document in
          do {
            if let result = try document.data(as: ResultType.self) {
              fetchedResult.append(result)
            }
          } catch { }
        })
        return fetchedResult
      })
  }
  //Fetch
}
