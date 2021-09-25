import Foundation

final class NLPUser: Codable {
  var email: String
  var nickname: String
  var bio: String
  var fires: Int = 0
  var participationCount: Int = 0
  var poems: [String] = []
  var likedPoem: [String] = []
  var blockedUser: [String] = []
  
  init(email: String, nickname: String, bio: String) {
    self.email = email
    self.nickname = nickname
    self.bio = bio
  }
}
