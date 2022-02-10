import UIKit

final class SceneCoordinator: Coordinator {
  var children: [Coordinator] = []
  var router: Router
  
  init(router: Router) {
    self.router = router
  }
  
  func present(
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    let launchViewController = LaunchViewController()
    
    launchViewController.delegate = self
    
    router.present(
      launchViewController,
      animated: false
    )
  }
}

//MARK: - LaunchViewControllerDelegate
extension SceneCoordinator: LaunchViewControllerDelegate {
  func presentNext(
    _ viewController: LaunchViewController,
    type: ViewControllerType
  ) {
    let nextViewController: UIViewController
    
    switch type {
    case .signin:
      let signinViewController = SignInViewController()
      signinViewController.delegate = self
      nextViewController = signinViewController
    case .main:
      nextViewController = NLPTabBarController()
    }
    
    router.present(
      nextViewController,
      animated: false
    )
  }
}

extension SceneCoordinator: SignInViewControllerDelegate {
  func signInAction(_ viewController: UIViewController) {
    let tabBarController = NLPTabBarController()
    router.present(tabBarController, animated: false)
  }
  
  func registerAction(_ viewController: UIViewController) {
    guard let router = router as? SceneRouter else {
      return
    }
    
    let signupViewController = SignUpViewController()
    router.presentModal(
      signupViewController,
      animated: true,
      onDismissed: nil
    )
  }
}
