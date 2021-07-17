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
}
