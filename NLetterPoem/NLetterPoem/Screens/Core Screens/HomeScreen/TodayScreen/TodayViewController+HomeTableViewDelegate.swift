import UIKit

extension TodayViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    fetchTodayViewControllerData(tableView)
  }
}
