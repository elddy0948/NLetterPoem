import UIKit

extension HomeViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    fetchTodayTopic(group: dispatchGroup)
    
    dispatchGroup.enter()
    fetchTodayPoems(group: dispatchGroup)
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
      tableView.reloadData()
      tableView.refreshControl?.endRefreshing()
    }
  }
}
