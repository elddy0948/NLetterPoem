import UIKit

extension TodayViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let poem = todayPoems?[indexPath.row] {
      delegate?.todayViewController(self, didSelected: poem)
      let viewController = PoemDetailViewController()
      viewController.poem = poem
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
}
