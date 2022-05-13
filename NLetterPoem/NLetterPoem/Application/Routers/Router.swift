import UIKit

//MARK: - Router
protocol Router: AnyObject {
  func present(_ viewController: UIViewController,
               animated: Bool,
               onDismissed: (() -> Void)?
  )
  
  func present(_ viewController: UIViewController,
               animated: Bool
  )
  
  func dismiss(animated: Bool)
}

//MARK: - Router extension
extension Router {
  func present(_ viewController: UIViewController,
               animated: Bool) {
    present(viewController,
            animated: animated,
            onDismissed: nil)
  }
}
