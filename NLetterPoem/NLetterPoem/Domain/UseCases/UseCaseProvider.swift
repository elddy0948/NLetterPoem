import Foundation

public protocol UseCaseProvider {
  func makePoemsUseCase() -> PoemUseCase
  func makeUserUseCase() -> UserUseCase
  func makeTopicUseCase() -> TopicUseCase
}
