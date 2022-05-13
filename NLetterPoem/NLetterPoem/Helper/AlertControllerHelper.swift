import UIKit

final class AlertControllerHelper {
  static func configureReportAlertController(
    _ viewController: UIViewController,
    userEmail: String,
    poem: Poem?
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    )
    
    let blockAction = UIAlertAction(
      title: "사용자 차단하기",
      style: .destructive) { action in
      }
    
    let reportAction = UIAlertAction(
      title: "신고하기",
      style: .destructive) { action in
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
