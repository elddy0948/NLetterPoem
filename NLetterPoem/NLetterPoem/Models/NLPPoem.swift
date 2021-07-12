import Foundation

final class NLPPoem: Codable {
    
    var id: String = UUID().uuidString
    let topic: String
    let author: String
    let authorEmail: String
    let content: String
    var ranking: Int
    var likeCount: Int = 0
    var createdAt: String = "\(Date().toYearMonthDay())"
    var created: String = "\(Date().timeIntervalSince1970)"
    
    init(topic: String, author: String, authorEmail: String, content: String, ranking: Int) {
        self.topic = topic
        self.author = author
        self.authorEmail = authorEmail
        self.content = content
        self.ranking = ranking
    }
    
    static func emptyPoem() -> NLPPoem {
        return NLPPoem(topic: "", author: "", authorEmail: "", content: "", ranking: Int.max)
    }
}
