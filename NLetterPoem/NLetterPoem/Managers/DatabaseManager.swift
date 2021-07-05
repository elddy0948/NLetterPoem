import Foundation
import Firebase
import FirebaseFirestoreSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    static var user: NLPUser?
    private let db = Firestore.firestore()
    private var ref: DocumentReference? = nil
    
    private init() {}
    
    func createUser(with user: NLPUser, completed: @escaping (NLPUser?) -> Void) {
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
            "poems": user.poems
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
    
    func updateUser(with user: NLPUser, completed: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(user.email).setData(from: user, merge: true)
            completed(nil)
        } catch {
            completed(error)
        }
    }
    
    func checkUserExist(with user: NLPUser, completed: @escaping (Bool) -> Void) {
        db.collection("users").document(user.email).getDocument { document, error in
            guard let document = document else {
                completed(false)
                return
            }
            
            if document.exists {
                print("Hello")
                completed(true)
            } else {
                completed(false)
            }
        }
    }
    
    func fetchUserInfo(with email: String, completed: @escaping (NLPUser?) -> Void) {
        db.collection("users").document(email).getDocument { document, error in
            let data = document?.data()
            let decoder = JSONDecoder()
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data as Any)
                let user = try decoder.decode(NLPUser.self, from: jsonData)
                completed(user)
            } catch {
                print(error)
                completed(nil)
            }
        }
    }
    
    func createPoem(with poem: NLPPoem, completed: @escaping(Error?) -> Void) {
        do {
            try db.collection("poems").document(poem.topic).setData(from: poem)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchTodayTopic(date: Date, completed: @escaping ((String?) -> Void)) {
        let stringDate = date.toYearMonthDay()
        db.collection("topics").document(stringDate).getDocument { document, error in
            guard let document = document else {
                completed(nil)
                return
            }
            
            do {
                let data = try document.data(as: Topic.self)
                completed(data?.topic)
            } catch {
                debugPrint(error)
                completed(nil)
            }
        }
    }
}
