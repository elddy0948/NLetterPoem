import UIKit
import Firebase
import RxSwift

extension HomeViewController {
  
  func setupCurrentUserSubscription() {
    currentUserViewModel.userSubject
      .subscribe(
        onNext: { [weak self] user in
          guard let self = self else { return }
          self.dismissLoadingView()
        },
        onError: { error in },
        onCompleted: {},
        onDisposed: {}
      )
      .disposed(by: disposeBag)
  }
  
  func checkUserDidWritePoemToday(with email: String?) {
    showLoadingView()
    guard let email = email else { return }
    DispatchQueue.global(qos: .userInitiated).async {
      PoemDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        self.dismissLoadingView()
        switch result {
        case .success(_):
          let viewController = CantCreatePoemViewController()
          viewController.user = self.currentUserViewModel.user
          self.createNavigationController(rootVC: viewController)
        case .failure(_):
          let viewController = CreateTopicViewController()
          viewController.user = self.currentUserViewModel.user
          self.createNavigationController(rootVC: viewController)
        }
      }
    }
  }
}
