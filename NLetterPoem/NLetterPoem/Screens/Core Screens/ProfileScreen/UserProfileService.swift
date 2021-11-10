import RxSwift
import Firebase

class UserProfileService {
  
  enum PoemSortType: String {
    case likeCount = "likeCount"
    case created = "created"
  }
  
  typealias ProfileUserResult = Result<ProfileUserViewModel, ProfileServiceError>
  typealias ProfilePoemsResult = Result<ProfilePoemsViewModel, ProfileServiceError>
  
  private var reference = Firestore.firestore()
  private let disposeBag = DisposeBag()
  
  func fetchUser(with email: String) -> Observable<ProfileUserResult> {
    return reference.collection("users").document(email).rx
      .getDocument().map({ snapshot -> ProfileUserResult in
        if let user = try snapshot.data(as: NLPUser.self) {
          let profileUserViewModel = ProfileUserViewModel(user)
          return .success(profileUserViewModel)
        } else {
          return .failure(.noUserExist)
        }
      })
  }
  
  func fetchPoems(with email: String,
                  sortType: PoemSortType,
                  descending: Bool) -> Observable<ProfilePoemsResult> {
    return reference.collection("poems")
      .whereField("authorEmail", isEqualTo: email)
      .rx.getDocuments().map({ snapshot -> ProfilePoemsResult in
        var poems = [NLPPoem]()
        for document in snapshot.documents {
          if let poem = try document.data(as: NLPPoem.self) {
            poems.append(poem)
          }
        }
        
        var sortedPoem = [NLPPoem]()
        
        switch sortType {
        case .likeCount:
          sortedPoem = descending ? poems.sorted(by: { $0.likeCount > $1.likeCount }) : poems.sorted(by: { $0.likeCount < $1.likeCount })
        case .created:
          sortedPoem = descending ? poems.sorted(by: { $0.created > $1.created }) : poems.sorted(by: { $0.created < $1.created })
        }
        
        let profilePoemsViewModel = ProfilePoemsViewModel(sortedPoem)
        
        return .success(profilePoemsViewModel)
      })
  }
}

enum ProfileServiceError: Error {
  case noUserExist
  
  var message: String {
    switch self {
    case .noUserExist:
      return "유저가 존재하지 않습니다.\n다시 시도해주세요!"
    }
  }
}
