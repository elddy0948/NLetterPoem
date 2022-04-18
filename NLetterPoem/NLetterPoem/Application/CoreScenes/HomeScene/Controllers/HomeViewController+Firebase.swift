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
    FirestorePoemApi.shared
      .read(email)
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onSuccess: { [weak self] poem in
          self?.dismissLoadingView()
          guard let self = self else { return }
          if poem.topic == "" {
            self.showCreateTopicViewController(
              with: self.currentUserViewModel.user
            )
          } else {
            self.showCantCreatePoemViewController(
              with: self.currentUserViewModel.user
            )
          }
        },
        onFailure: { error in },
        onDisposed: {}
      )
      .disposed(by: disposeBag)
  }
  
  private func showCantCreatePoemViewController(with user: NLPUser) {
    let viewController = CantCreatePoemViewController()
    viewController.user = user
    createNavigationController(rootVC: viewController)
  }
  
  private func showCreateTopicViewController(with user: NLPUser) {
    let viewController = CreateTopicViewController()
    viewController.user = user
    createNavigationController(rootVC: viewController)
  }
}
