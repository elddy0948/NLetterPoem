import Foundation

final class NLPUser: Codable {
    static var shared: NLPUser?

    var email: String
    var password: String
    var profilePhotoURL: String
    var nickname: String
    var bio: String
    var firstPlaceCount: Int
    var secondPlaceCount: Int
    var thirdPlaceCount: Int
    var participationCount: Int
    
    init(email: String, password: String, profilePhotoURL: String, nickname: String, bio: String,
         firstPlaceCount: Int = 0, secondPlaceCount: Int = 0, thirdPlaceCount: Int = 0, participationCount: Int = 0) {
        self.email = email
        self.password = password
        self.profilePhotoURL = profilePhotoURL
        self.nickname = nickname
        self.bio = bio
        self.firstPlaceCount = firstPlaceCount
        self.secondPlaceCount = secondPlaceCount
        self.thirdPlaceCount = thirdPlaceCount
        self.participationCount = participationCount
    }
}
