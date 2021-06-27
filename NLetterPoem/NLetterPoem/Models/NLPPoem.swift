import Foundation

final class NLPPoem: Codable {
    let author: String
    let content: String
    var ranking: Int
    var likeCount: Int = 0
    var createdAt: Date = Date()
    
    init(author: String, content: String, ranking: Int) {
        self.author = author
        self.content = content
        self.ranking = ranking
    }
}
