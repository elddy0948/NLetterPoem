import Foundation
import Firebase
import FirebaseFirestoreSwift

final class PoemDatabaseManager {
    
    //MARK: - Static
    static let shared = PoemDatabaseManager()
    
    //MARK: - Properties
    private let database = Firestore.firestore()
    private let poemDatabaseQueue = DispatchQueue(label: "com.howift.poemDB")
    private let poemReference: CollectionReference
    private let topicReference: CollectionReference
    
    private init() {
        poemReference = database.collection("poems")
        topicReference = database.collection("topics")
    }
    
    //MARK: - Poem
    func createPoem(poem: NLPPoem, completed: @escaping ((Error?) -> Void)) {
        do {
            try self.poemReference.document(poem.id).setData(from: poem)
        } catch {
            debugPrint(error)
        }
        
    }
    
    func fetchTodayTopic(date: Date, completed: @escaping ((String?) -> Void)) {
        let stringDate = date.toYearMonthDay()
        
        topicReference.document(stringDate).getDocument { document, error in
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
        let query = poemReference.whereField("createdAt", isEqualTo: "\(stringDate)")
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
        let query = poemReference.whereField("authorEmail", isEqualTo: userEmail)
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
        let query = poemReference.whereField("createdAt", isEqualTo: "\(stringDate)")
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
    
    func updatePoemLikeCount(id: String, authorEmail: String, isIncrease: Bool) {
        let poemRef = database.collection("poems").document(id)
        let userRef = database.collection("users").document(authorEmail)
        let count = isIncrease ? 1 : -1
        
        poemRef.updateData([
            "likeCount": FieldValue.increment(Int64(count))
        ])
        userRef.updateData([
            "fires": FieldValue.increment(Int64(count))
        ])
    }
    
    enum SortType {
        case like
        case recent
    }
}
