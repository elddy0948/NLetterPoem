import Foundation

public struct NLetterPoem {
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

extension NLetterPoem {
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

extension NLetterPoem {
  var empty: NLetterPoem {
    return NLetterPoem(
      topic: "",
      author: "",
      authorEmail: "",
      content: "",
      ranking: Int.max
    )
  }
}
