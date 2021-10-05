import UIKit
import Firebase
import RxSwift

class HomeViewModel {
  var nlpUser = PublishSubject<NLPUser?>()
  var user = PublishSubject<User?>()
    
  private let userDatabaseReference = Firestore.firestore().collection("users")
  private let disposeBag = DisposeBag()
  
  func createAuthStateChangeHandler() -> Observable<User> {
    Auth.auth().rx.configureStateChangeListener()
  }
  
  func fetchUserInfo(with email: String) -> Observable<NLPUser?> {
    userDatabaseReference.document(email).rx.getDocument()
      .map({ snapshot in
        try snapshot.data(as: NLPUser.self)
      })
      .catchAndReturn(nil)
  }
  
  deinit {
    print("deinit")
  }
}
