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
    let navigationController = UINavigationController()
    
    let navigationRouter = NavigationRouter(
      navigationController: navigationController
    )
    
    let coordinator = LaunchCoordinator(
      router: navigationRouter
    )
    
    router.present(
      navigationController,
      animated: animated
    )
    
    presentChild(
      coordinator,
      animated: true,
      onDismissed: nil
    )
  }
}
