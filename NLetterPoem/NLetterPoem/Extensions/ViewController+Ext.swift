import UIKit

extension UIViewController {
  func showAlert(title: String, message: String, action: ((UIAlertAction) -> Void)?) {
    DispatchQueue.main.async {
      let presentedViewController = self.presentedViewController
      
      if presentedViewController is UIAlertController {
        return
      }
      
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "닫기", style: .cancel, handler: action)
      alertController.addAction(action)
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  func add(_ childViewController: UIViewController) {
    addChild(childViewController)
    view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }
  
  func remove() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
}
