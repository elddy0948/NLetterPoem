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
