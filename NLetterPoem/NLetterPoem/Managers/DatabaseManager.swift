import Foundation
import Firebase
import FirebaseFirestoreSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    static var user: NLPUser?
    private let db = Firestore.firestore()
    private var ref: DocumentReference? = nil
    
    private init() {}
    
    //MARK: - User
    func createUser(with user: NLPUser, completed: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(user.email).setData(from: user)
            completed(nil)
        } catch {
            completed(error)
            return
        }
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
    
    //MARK: - Poem
    func createPoem(poem: NLPPoem, completed: @escaping ((Error?) -> Void)) {
        do {
            try db.collection("poems").document(poem.id).setData(from: poem)
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
    
    func fetchTodayPoems(date: Date, completed: @escaping (([NLPPoem]) -> Void)) {
        let stringDate = date.toYearMonthDay()
        let poemRef = db.collection("poems")
        let query = poemRef.whereField("createdAt", isEqualTo: "\(stringDate)")
        var poems = [NLPPoem]()
        
        query.getDocuments { snapshot, error in
            guard let querySnapshot = snapshot else {
                completed([])
                return
            }
            
            for document in querySnapshot.documents {
                do {
                    let poem = try document.data(as: NLPPoem.self) ?? NLPPoem.emptyPoem()
                    poems.append(poem)
                } catch {
                    completed([])
                    return
                }
            }
            
            completed(poems)
        }
    }
    
    func fetchUserPoems(userEmail: String, completed: @escaping (([NLPPoem]) -> Void)) {
        let poemRef = db.collection("poems")
        let query = poemRef.whereField("authorEmail", isEqualTo: userEmail)
        var userPoems = [NLPPoem]()
        
        query.getDocuments { snapshot, error in
            guard let querySnapshot = snapshot else {
                completed([])
                return
            }
            
            for document in querySnapshot.documents {
                do {
                    let poem = try document.data(as: NLPPoem.self) ?? NLPPoem.emptyPoem()
                    userPoems.append(poem)
                } catch {
                    completed([])
                    return
                }
            }
            
            completed(userPoems)
        }
    }
    
    func sortPoems(by sortType: SortType, date: Date, completed: @escaping ([NLPPoem]) -> Void) {
        let stringDate = date.toYearMonthDay()
        let poemRef = db.collection("poems")
        let query = poemRef.whereField("createdAt", isEqualTo: "\(stringDate)")
        var poems = [NLPPoem]()
        
        query.getDocuments { snapshot, error in
            guard let querySnapshot = snapshot else {
                completed([])
                return
            }
            
            for document in querySnapshot.documents {
                do {
                    let poem = try document.data(as: NLPPoem.self) ?? NLPPoem.emptyPoem()
                    poems.append(poem)
                } catch {
                    completed([])
                    return
                }
            }
            
            switch sortType {
            case .like:
                let likePoems = poems.sorted { $0.likeCount > $1.likeCount }
                completed(likePoems)
            case .recent:
                let recentPoems = poems.sorted { $0.created > $1.created }
                completed(recentPoems)
            }
        }
    }
    
    func updatePoemLikeCount(id: String, isIncrease: Bool) {
        let poemRef = db.collection("poems").document(id)
        let count = isIncrease ? 1 : -1
        
        poemRef.updateData([
            "likeCount": FieldValue.increment(Int64(count))
        ])
    }
    
    enum SortType {
        case like
        case recent
    }
}
