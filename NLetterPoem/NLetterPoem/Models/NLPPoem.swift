import Foundation

final class NLPPoem: Codable {
    
    var id: String
    let topic: String
    let author: String
    let content: String
    var ranking: Int
    var likeCount: Int = 0
    var createdAt: String = "\(Date().timeIntervalSince1970)"
    
    init(id: String, topic: String, author: String, content: String, ranking: Int) {
        self.id = id + UUID().uuidString
        self.topic = topic
        self.author = author
        self.content = content
        self.ranking = ranking
    }
}
