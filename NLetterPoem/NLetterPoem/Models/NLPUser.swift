import Foundation

final class NLPUser: Codable {
    static var shared: NLPUser?

    var email: String
    var profilePhotoURL: String
    var nickname: String
    var bio: String
    var fires: Int = 0
    var participationCount: Int = 0
    var poems: [String] = []
    var likedPoem: [String] = []
    
    init(email: String, profilePhotoURL: String, nickname: String, bio: String) {
        self.email = email
        self.profilePhotoURL = profilePhotoURL
        self.nickname = nickname
        self.bio = bio
    }
}
