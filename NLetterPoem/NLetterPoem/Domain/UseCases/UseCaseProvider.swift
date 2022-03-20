import Foundation

public protocol UseCaseProvider {
  func makePoemsUseCase() -> PoemsUseCase
  func makeUserUseCase() -> UserUseCase
  func makeTopicUseCase() -> TopicUseCase
}
