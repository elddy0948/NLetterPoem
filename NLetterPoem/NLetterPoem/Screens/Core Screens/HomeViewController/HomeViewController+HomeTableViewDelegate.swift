import UIKit

extension HomeViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    PoemDatabaseManager.shared.fetchTodayTopic(date: Date()) { [weak self] topic in
      guard let self = self else { return }
      defer { dispatchGroup.leave() }
      self.todayTopic = topic
    }
    
    dispatchGroup.enter()
    PoemDatabaseManager.shared.fetchTodayPoems(date: Date()) { [weak self] poems in
      guard let self = self else { return }
      defer { dispatchGroup.leave() }
      self.todayPoems = poems
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
      tableView.reloadData()
      tableView.refreshControl?.endRefreshing()
    }
  }
}
