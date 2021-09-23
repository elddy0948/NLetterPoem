import Foundation

enum SigninError: Error {
    static let failedSignIn = "로그인에 실패했습니다\n이메일과 패스워드를 확인해주세요!👀"
    static let emptyField = "이메일과 패스워드를 입력해주세요!👀"
}

enum UserFirestoreError: Error {
  case failedCreateUser
  case failedReadUser
  case failedUpdateUser
  case failedDeleteUser
  case failedToFetchTopTenUsers
  case failedDeletePoemFromUser
  case failedUnlikePoem
  case failedBlockUser
  
  var message: String {
    switch self {
    case .failedCreateUser:
      return "유저 생성에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedReadUser:
      return "유저를 읽어오지 못했습니다!\n다시 시도해주세요!🙏"
    case .failedUpdateUser:
      return "업데이트에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedDeleteUser:
      return "삭제에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedToFetchTopTenUsers:
      return "유저를 불러오지 못했습니다!\n다시 시도해주세요!🙏"
    case .failedDeletePoemFromUser:
      return "삭제에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedUnlikePoem:
      return "오류가 발생했습니다!\n다시 시도해주세요!🙏"
    case .failedBlockUser:
      return "차단에 실패했습니다!\n다시 시도해주세요!🙏"
    }
  }
}

enum PoemFirestoreError: Error {
  case failedCreatePoem
  case failedUpdatePoem
  case failedDeletePoem
  case failedReadTodayPoems
  case failedReadPoem
  case failedLike
  
  var message: String {
    switch self {
    case .failedCreatePoem:
      return "생성에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedUpdatePoem:
      return "업데이트에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedDeletePoem:
      return "삭제에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedReadTodayPoems:
      return "불러오기에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedReadPoem:
      return "불러오기에 실패했습니다!\n다시 시도해주세요!🙏"
    case .failedLike:
      return "문제가 생겼습니다!\n다시 시도해주세요!🙏"
    }
  }
}

enum TopicFirestoreError: Error {
  case failedReadTopic
  
  var message: String {
    switch self {
    case .failedReadTopic:
      return "주제를 읽어오지 못했습니다!\n다시 시도해주세요!🙏"
    }
  }
}

enum AuthError: Error {
  case failedDeleteUser
}

enum ReportError: Error {
  case failedReport
  var message: String {
    switch self {
    case .failedReport:
      return "신고에 실패했습니다!\n다시 시도해주세요!🙏"
    }
  }
}
