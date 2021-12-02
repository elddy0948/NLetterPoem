import UIKit

final class AlertControllerHelper {
  static func configureReportAlertController(
    _ viewController: UIViewController,
    user: NLPUser,
    poemViewModel: PoemViewModel
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    )
    
    let blockAction = UIAlertAction(
      title: "사용자 차단하기",
      style: .destructive) { action in
        UserDatabaseManager.shared.block(
          userEmail: user.email,
          blockEmail: poemViewModel.authorEmail) { result in
            switch result {
            case .success(let message):
              viewController.showAlert(
                title: "✅",
                message: message,
                action: nil
              )
            case .failure(let error):
              viewController.showAlert(
                title: "⚠️",
                message: error.message,
                action: nil)
            }
          }
      }
    
    let reportAction = UIAlertAction(
      title: "신고하기",
      style: .destructive) { action in
        ReportDatabaseManager.shared.create(
          user: user.email,
          reportedPoem: poemViewModel,
          reportMessage: "신고!") { result in
            switch result {
            case .success(let message):
              viewController.showAlert(
                title: "✅",
                message: message,
                action: nil
              )
            case .failure(let error):
              viewController.showAlert(
                title: "⚠️",
                message: error.message,
                action: nil
              )
            }
          }
      }
    
    let cancelAction = UIAlertAction(
      title: "취소",
      style: .cancel,
      handler: nil
    )
    
    alertController.addAction(blockAction)
    alertController.addAction(reportAction)
    alertController.addAction(cancelAction)
    
    return alertController
  }
}
