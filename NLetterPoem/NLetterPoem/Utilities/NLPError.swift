import Foundation

enum SigninError: Error {
    static let failedSignIn = "로그인에 실패했습니다\n이메일과 패스워드를 확인해주세요!👀"
    static let emptyField = "이메일과 패스워드를 입력해주세요!👀"
}

enum PoemDatabaseError: Error {
    case notAuthor
    case failedDelete
    
    var message: String {
        switch self {
        case .notAuthor:
            return "권한이 없습니다.\n다시 시도해주세요!😅"
        case .failedDelete:
            return "삭제에 실패했습니다.\n다시 시도해주세요!😅"
        }
    }
}

enum UserDatabaseError: Error {
    case failedToDelete
    case noAuthority
    
    var message: String {
        switch self {
        case .failedToDelete:
            return "삭제에 실패했어요!\n다시 시도해주세요😅"
        case .noAuthority:
            return "권한이 없습니다!\n다시 시도해주세요😅"
        }
    }
}

enum DatabaseError: Error {
  case failedCreateUser
  case failedUpdateUser
  case failedDeleteUser
  case failedReadUser
  
  case failedToFetchTopTenUsers
  
  case failedDeletePoemFromUser
  case failedUnlikePoem
  
  case failedUpdatePoem
  case failedDeletePoem
  case failedReadTodayPoems
  case failedReadPoem
  
  case failedReadTopic
}

enum AuthError: Error {
  case failedDeleteUser
}
