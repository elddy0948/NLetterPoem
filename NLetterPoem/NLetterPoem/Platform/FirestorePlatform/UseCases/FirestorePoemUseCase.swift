import Foundation
import RxSwift

final class FirestorePoemUseCase: PoemUseCase {
  private let collection: PoemCollection
  
  init(collection: PoemCollection) {
    self.collection = collection
  }
  
  func create(_ poem: Poem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.createPoem(poemDTO)
  }
  
  func update(_ poem: Poem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.updatePoem(poemDTO)
  }
  
  func delete(_ poem: Poem) -> Completable {
    let poemDTO = PoemDTO(poem: poem)
    return collection.deletePoem(poemDTO)
  }
  
  func readPoems(query: PoemQuery) -> Observable<[Poem]> {
    return collection.fetchPoems(query: query)
      .map({ $0.map({ $0.toDomain() })})
  }
  
  func readPoem(_ id: String) -> Observable<Poem> {
    return collection.fetchPoem(id)
      .map({ $0.toDomain() })
  }
  
  func readPoems(query: NLetterQuery?, by order: String, limit: Int) -> Observable<(NLetterQuery?, [Poem])> {
    return collection.fetchPoems(
      query: query, order: order, limit: limit
    ).map({ (query, poemDTOs) in
      return (query, poemDTOs.map({ $0.toDomain() }))
    })
  }
}
