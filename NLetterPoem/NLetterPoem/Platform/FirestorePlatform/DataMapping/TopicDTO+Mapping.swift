import Foundation

struct TopicDTO: Codable {
  let topic: String
}

extension TopicDTO {
  func toDomain() -> NLetterTopic {
    return NLetterTopic(topic: topic)
  }
}
