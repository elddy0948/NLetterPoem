import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, action: ((UIAlertAction) -> Void)?) {
        if self.presentedViewController is UIAlertController {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "닫기", style: .cancel, handler: action)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
