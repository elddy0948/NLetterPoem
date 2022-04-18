import Foundation
import RxSwift

final class FirestorePoemUseCase: PoemUseCase {
  private let collection: PoemCollection
  
  init(collection: PoemCollection) {
    self.collection = collection
  }
  
  func create(_ poem: NLetterPoem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.createPoem(poemDTO)
  }
  
  func update(_ poem: NLetterPoem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.updatePoem(poemDTO)
  }
  
  func delete(_ poem: NLetterPoem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.deletePoem(poemDTO)
  }
  
  func readPoems(query: PoemQuery) -> Observable<[NLetterPoem]> {
    return collection.fetchPoems(query: query)
      .map({ $0.map({ $0.toDomain() })})
  }
  
  func readPoem(_ id: String) -> Observable<NLetterPoem> {
    return collection.fetchPoem(id)
      .map({ $0.toDomain() })
  }
}
