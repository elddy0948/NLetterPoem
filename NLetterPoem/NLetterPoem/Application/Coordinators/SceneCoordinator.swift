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
  func presentTabBarController(_ viewController: LaunchViewController) {
    presentMainTabBarController()
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
