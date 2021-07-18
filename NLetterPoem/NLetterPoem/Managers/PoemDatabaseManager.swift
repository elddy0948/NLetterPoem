import Foundation
import Firebase
import FirebaseFirestoreSwift

final class PoemDatabaseManager {
    
    //MARK: - Static
    static let shared = PoemDatabaseManager()
    
    //MARK: - Properties
    private let database = Firestore.firestore()
    private let poemDatabaseQueue = DispatchQueue(label: "com.howift.poemDB")
    
    private init() {}

    //MARK: - Poem
    func createPoem(poem: NLPPoem, completed: @escaping ((Error?) -> Void)) {
        do {
            try database.collection("poems").document(poem.id).setData(from: poem)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchTodayTopic(date: Date, completed: @escaping ((String?) -> Void)) {
        let stringDate = date.toYearMonthDay()
        
        database.collection("topics").document(stringDate).getDocument { document, error in
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
        let poemRef = database.collection("poems")
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
        let poemRef = database.collection("poems")
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
        let poemRef = database.collection("poems")
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
        let poemRef = database.collection("poems").document(id)
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
