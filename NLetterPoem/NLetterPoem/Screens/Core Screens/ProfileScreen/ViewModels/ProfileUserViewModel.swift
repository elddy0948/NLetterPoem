import Foundation

struct ProfileUserViewModel {
  let user: NLPUser
}

extension ProfileUserViewModel {
  init(_ user: NLPUser) {
    self.user = user
  }
}

extension ProfileUserViewModel {
  var nickname: String {
    return user.nickname
  }

  var fires: Int {
    return user.fires
  }
  
  var bio: String {
    return user.bio
  }
}
