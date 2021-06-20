import Foundation
import Firebase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    private var ref: DocumentReference? = nil
    
    private init() {}
    
    func createUser(with user: User, completed: @escaping (User?) -> Void) {
        db.collection("users").document(user.email).setData([
            "email": user.email,
            "password": user.password,
            "nickname": user.nickname,
            "profilePhotoURL": user.profilePhotoURL,
            "bio": user.bio,
            "firstPlaceCount": user.firstPlaceCount,
            "secondPlaceCount": user.secondPlaceCount,
            "thirdPlaceCount": user.thirdPlaceCount,
            "participationCount": user.participationCount,
        ], completion: { error in
            if let error = error {
                print(error)
                completed(nil)
            } else {
                print("Document added with ID: \(self.ref?.documentID)")
                completed(user)
            }
        })
    }
    
    func checkUserExist(with user: User, completed: @escaping (Bool) -> Void) {
        db.collection("users").document(user.email).getDocument(source: .cache) { document, error in
            guard let document = document else {
                completed(false)
                return
            }
            
            if document.exists {
                completed(true)
            } else {
                completed(false)
            }
        }
    }
}
