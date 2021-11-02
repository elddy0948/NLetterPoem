import RxSwift
import Firebase

class UserProfileService {
  
  let userViewModel = PublishSubject<ProfileUserViewModel>()
  let poemsViewModel = PublishSubject<ProfilePoemsViewModel>()
  
  private var reference = Firestore.firestore()
  private let disposeBag = DisposeBag()
  
  func fetchUser(with email: String) {
    return reference.collection("users").document(email).rx
      .getDocument().map({ snapshot -> NLPUser? in
        if let user = try snapshot.data(as: NLPUser.self) {
          return user
        } else {
          return nil
        }
      }).subscribe(onNext: { [weak self] user in
        if let user = user,
           let self = self {
          self.userViewModel.onNext(ProfileUserViewModel(user))
        }
      }).disposed(by: disposeBag)
  }
  
  func fetchPoems(with email: String) -> Observable<[NLPPoem]> {
    return reference.collection("poems")
      .whereField("authorEmail", isEqualTo: email)
      .rx.getDocuments().map({ snapshot -> [NLPPoem] in
        var poems = [NLPPoem]()
        for document in snapshot.documents {
          if let poem = try document.data(as: NLPPoem.self) {
            poems.append(poem)
          }
        }
        return poems
      })
  }
}
