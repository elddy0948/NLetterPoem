import Foundation

public struct Poem: Codable {
  let id: String
  let topic: String
  let author: String
  let authorEmail: String
  var content: String
  let ranking: Int
  let likeCount: Int
  let createdAt: String
  let created: String
}

extension Poem {
  init(topic: String,
       author: String,
       authorEmail: String,
       content: String, ranking: Int) {
    self.id = UUID().uuidString
    self.topic = topic
    self.author = author
    self.authorEmail = authorEmail
    self.content = content
    self.ranking = ranking
    self.likeCount = 0
    self.createdAt = Date().toYearMonthDay()
    self.created = "\(Date().timeIntervalSinceReferenceDate)"
  }
}

extension Poem {
  static var empty: Poem {
    return Poem(
      topic: "",
      author: "",
      authorEmail: "",
      content: "",
      ranking: Int.max
    )
  }
}
