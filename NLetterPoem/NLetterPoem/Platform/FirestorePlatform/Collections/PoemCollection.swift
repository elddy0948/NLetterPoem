import Foundation
import RxSwift
import FirebaseFirestore

public final class PoemCollection {
  private let network: FirestoreNetwork<PoemDTO>
  
  init(network: FirestoreNetwork<PoemDTO>) {
    self.network = network
  }
  
  public func fetchPoems(query: Query) -> Observable<[PoemDTO]> {
    return network.getItems(query)
  }
  
  public func fetchPoem(_ id: String) -> Observable<PoemDTO> {
    return network.getItem(id)
  }
  
  public func createPoem(_ poem: PoemDTO) -> Completable {
    return network.create(itemId: poem.id, item: poem)
  }
  
  public func updatePoem(_ poem: PoemDTO) -> Completable {
    return network.update(poem.id, item: poem)
  }
  
  public func deletePoem(_ poem: PoemDTO) -> Completable {
    return network.delete(poem.id)
  }
}
