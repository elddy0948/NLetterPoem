import Foundation
import FirebaseAuth

class AuthManager {
  static let shared = AuthManager()
  
  private let auth = Auth.auth()
  
  private init() {}
  
  func createUser(with info: SignupInfo, completed: @escaping (Result<String, Error>) -> Void) {
    auth.createUser(withEmail: info.email, password: info.password) { result, error in
      if let error = error {
        completed(.failure(error))
        return
      }
      completed(.success("환영합니다!"))
    }
  }
  
  func signin(email: String, password: String, completed: @escaping (Error?) -> Void) {
    auth.signIn(withEmail: email, password: password) { result, error in
      guard error == nil,
            result != nil else {
        completed(error)
        return
      }
      completed(nil)
    }
  }

  func authDelete(userEmail: String, completed: @escaping (Result<String, AuthError>) -> Void) {
    guard let user = auth.currentUser else {
      completed(.failure(.failedDeleteUser))
      return
    }
    
    user.delete { error in
      if error != nil {
        completed(.failure(.failedDeleteUser))
        return
      }
      completed(.success("삭제에 성공했습니다!"))
    }
  }
}
