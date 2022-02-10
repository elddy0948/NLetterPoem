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
    switch type {
    case .signin:
      presentSignInViewController()
    case .main:
      presentMainTabBarController()
    }
  }
  
  private func presentSignInViewController() {
    let signinViewController = SignInViewController()
    signinViewController.delegate = self
    router.present(signinViewController, animated: false)
  }
  
  private func presentMainTabBarController() {
    let tabBarController = NLPTabBarController()
    let tabBarRouter = TabBarRouter(
      tabBarController: tabBarController
    )
    
    let mainTabBarCoordinator = MainTabBarCoordinator(
      router: tabBarRouter
    )
    
    router.present(tabBarController, animated: false)
    
    presentChild(
      mainTabBarCoordinator,
      animated: false,
      onDismissed: nil
    )
  }
}

extension SceneCoordinator: SignInViewControllerDelegate {
  func signInAction(_ viewController: UIViewController) {
    presentMainTabBarController()
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
