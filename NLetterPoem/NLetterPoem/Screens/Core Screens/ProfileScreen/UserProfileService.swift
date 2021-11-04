import RxSwift
import Firebase

class UserProfileService {
  
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
  
  func fetchPoems(with email: String) -> Observable<ProfilePoemsResult> {
    return reference.collection("poems")
      .whereField("authorEmail", isEqualTo: email)
      .rx.getDocuments().map({ snapshot -> ProfilePoemsResult in
        var poems = [NLPPoem]()
        for document in snapshot.documents {
          if let poem = try document.data(as: NLPPoem.self) {
            poems.append(poem)
          }
        }
        let profilePoemsViewModel = ProfilePoemsViewModel(poems)
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
