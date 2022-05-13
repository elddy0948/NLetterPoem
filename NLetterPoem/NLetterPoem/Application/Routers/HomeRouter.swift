import UIKit

final class HomeRouter: Router {
  private var navigationController: UINavigationController
  
  init(navController: UINavigationController) {
    self.navigationController = navController
  }
  
  func present(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    navigationController.pushViewController(
      viewController,
      animated: true
    )
  }
  
  func dismiss(animated: Bool) {
    
  }
}
