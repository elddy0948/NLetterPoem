import UIKit

class SignInRegisterRouter: Router {
  private let rootViewController: UIViewController
  
  init(rootViewcontroller: UIViewController) {
    self.rootViewController = rootViewcontroller
  }
  func present(
    _ viewController: UIViewController,
    animated: Bool,
    onDismissed: (() -> Void)?
  ) {
    rootViewController.present(
      viewController,
      animated: true,
      completion: nil
    )
  }
  
  func dismiss(animated: Bool) {
  }
}
