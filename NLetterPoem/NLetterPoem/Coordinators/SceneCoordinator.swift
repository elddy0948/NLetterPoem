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
    let viewController = LaunchViewController()
    let navigationController = UINavigationController(
      rootViewController: viewController
    )
    
    router.present(
      navigationController,
      animated: animated
    )
  }
}
