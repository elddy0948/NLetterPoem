import Foundation

enum SigninError: Error {
    static let failedSignIn = "로그인에 실패했습니다\n이메일과 패스워드를 확인해주세요!👀"
    static let emptyField = "이메일과 패스워드를 입력해주세요!👀"
}
