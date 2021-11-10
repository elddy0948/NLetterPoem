import UIKit

extension TodayViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let poem = todayTableViewDataSource.fetchPoem(from: indexPath)
    delegate?.todayViewController(self, didSelected: poem)
  }
}
