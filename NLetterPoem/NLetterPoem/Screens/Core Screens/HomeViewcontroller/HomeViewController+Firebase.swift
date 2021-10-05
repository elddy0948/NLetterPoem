import UIKit
import Firebase
import RxSwift

extension HomeViewController {
  //TODO: - 스케쥴러에 추가하기
  func configureStateChangeListener() {
    showLoadingView()
    homeViewModel?.createAuthStateChangeHandler()
      .subscribe(onNext: { user in
        self.user = user
      })
      .disposed(by: disposeBag)
  }
  
  func fetchUserInfo(with email: String?) {
    guard let email = email else { return }
    homeViewModel?.fetchUserInfo(with: email)
      .subscribe(onNext: { [weak self] nlpUser in
        guard let self = self else { return }
        HomeViewController.nlpUser = nlpUser
        self.todayBarButtonAction(self.todayBarButton)
      }, onCompleted: { [weak self] in
        self?.dismissLoadingView()
      })
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
