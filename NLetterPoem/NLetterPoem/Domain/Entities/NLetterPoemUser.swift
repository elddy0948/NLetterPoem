import Foundation

struct NLetterPoemUser {
  let email: String
  let nickname: String
  let bio: String
  let fires: Int
  let participationCount: Int
  let poems: [String]
  let likedPoem: [String]
  let blockedUser: [String]
}

extension NLetterPoemUser {
  //MARK: - Initializer
  init(email: String,
       nickname: String,
       bio: String) {
    self.email = email
    self.nickname = nickname
    self.bio = bio
    self.fires = 0
    self.participationCount = 0
    self.poems = []
    self.likedPoem = []
    self.blockedUser = []
  }
}

extension NLetterPoemUser {
  var empty: NLetterPoemUser {
    return NLetterPoemUser(email: "",
                           nickname: "",
                           bio: "")
  }
}
