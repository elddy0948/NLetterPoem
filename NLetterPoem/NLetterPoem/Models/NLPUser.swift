import Foundation

final class NLPUser: Codable {
    static var shared: NLPUser?

    var email: String
    var password: String
    var profilePhotoURL: String
    var nickname: String
    var bio: String
    var firstPlaceCount: Int = 0
    var secondPlaceCount: Int = 0
    var thirdPlaceCount: Int = 0
    var participationCount: Int = 0
    var poems: [String] = []
    var likedPoem: [String] = []
    
    init(email: String, password: String, profilePhotoURL: String, nickname: String, bio: String) {
        self.email = email
        self.password = password
        self.profilePhotoURL = profilePhotoURL
        self.nickname = nickname
        self.bio = bio
    }
}
