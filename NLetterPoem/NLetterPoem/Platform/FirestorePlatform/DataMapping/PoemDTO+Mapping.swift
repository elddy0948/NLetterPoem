import Foundation

public struct PoemDTO: Codable {
  let id: String
  let topic: String
  let author: String
  let authorEmail: String
  let content: String
  let ranking: Int
  let likeCount: Int
  let createdAt: String
  let created: String
}

extension PoemDTO {
  func toDomain() -> NLetterPoem {
    return NLetterPoem(
      id: id,
      topic: topic,
      author: author,
      authorEmail: authorEmail,
      content: content,
      ranking: ranking,
      likeCount: likeCount,
      createdAt: createdAt,
      created: created
    )
  }
}

