import UIKit
import Firebase

extension HomeViewController {
  func createStateChangeListener() {
    showLoadingView()
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.handler = Auth.auth().addStateDidChangeListener { auth, user in
        guard let self = self,
              let user = user,
              let email = user.email else { return }
        UserDatabaseManager.shared.read(email) { result in
          defer { self.dismissLoadingView() }
          switch result {
          case .success(let user):
            HomeViewController.nlpUser = user
            self.todayBarButtonAction(self.todayBarButton)
          case .failure(let error):
            debugPrint(error.message)
          }
        }
      }
    }
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
          viewController.user = HomeViewController.nlpUser
          self.createNavigationController(rootVC: viewController)
        case .failure(_):
          let viewController = CreateTopicViewController()
          viewController.user = HomeViewController.nlpUser
          self.createNavigationController(rootVC: viewController)
        }
      }
    }
  }
}
