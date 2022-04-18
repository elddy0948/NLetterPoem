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
  
  init(poem: NLetterPoem) {
    self.id = poem.id
    self.topic = poem.topic
    self.author = poem.author
    self.authorEmail = poem.authorEmail
    self.content = poem.content
    self.ranking = poem.ranking
    self.likeCount = poem.likeCount
    self.createdAt = poem.createdAt
    self.created = poem.created
  }
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

