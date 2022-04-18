import Foundation

final class FirestoreUsecaseProvider: UseCaseProvider {
  private let networkProvider: FirestoreNetworkProvider
  
  init() {
    self.networkProvider = FirestoreNetworkProvider()
  }
  
  func makePoemsUseCase() -> PoemUseCase {
    let network = networkProvider.makePoemCollection()
    return FirestorePoemUseCase(collection: network)
  }
  
  func makeUserUseCase() -> UserUseCase {
    let network = networkProvider.makeUserCollection()
    return FirestoreUserUseCase(collection: network)
  }
  
  func makeTopicUseCase() -> TopicUseCase {
    let network = networkProvider.makeTopicCollection()
    return FirestoreTopicUseCase(collection: network)
  }
}
