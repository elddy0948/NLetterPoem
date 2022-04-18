import Foundation

struct UserDTO: Codable {
  let email: String
  let nickname: String
  let bio: String
  let fires: Int
  let participationCount: Int
  let poems: [String]
  let likedPoem: [String]
  let blockedUser: [String]
  
  init(_ user: NLetterPoemUser) {
    self.email = user.email
    self.nickname = user.nickname
    self.bio = user.bio
    self.fires = user.fires
    self.participationCount = user.participationCount
    self.poems = user.poems
    self.likedPoem = user.likedPoem
    self.blockedUser = user.blockedUser
  }
}

extension UserDTO {
  func toDomain() -> NLetterPoemUser {
    return NLetterPoemUser(
      email: email,
      nickname: nickname,
      bio: bio,
      fires: fires,
      participationCount: participationCount,
      poems: poems,
      likedPoem: likedPoem,
      blockedUser: blockedUser
    )
  }
}
