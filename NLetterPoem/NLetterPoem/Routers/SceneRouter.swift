import UIKit

class SceneRouter: Router {
  private var window: UIWindow
  private var rootViewController: UIViewController?
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func present(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
  
  func presentModal(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    window.rootViewController?.present(
      viewController,
      animated: animated,
      completion: nil
    )
  }
  
  func dismiss(animated: Bool) {
  }
}
