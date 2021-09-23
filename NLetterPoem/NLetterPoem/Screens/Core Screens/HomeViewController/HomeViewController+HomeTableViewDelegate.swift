import UIKit

extension HomeViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    DispatchQueue.global(qos: .utility).async {
      ToopicDatabaseManager.shared.read(date: Date()) { [weak self] result in
        defer { dispatchGroup.leave() }
        guard let self = self else { return }
        switch result {
        case .success(let topic):
          self.todayTopic = topic
        case .failure(_):
          self.todayTopic = ""
        }
      }
    }
    
    dispatchGroup.enter()
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.fetchTodayPoems(date: Date(), sortType: .recent) { [weak self] result in
        defer { dispatchGroup.leave() }
        guard let self = self else { return }
        switch result {
        case .success(let fetchedPoems):
          self.todayPoems = fetchedPoems
        case .failure(_):
          self.todayPoems = []
        }
      }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
      tableView.reloadData()
      tableView.refreshControl?.endRefreshing()
    }
  }
}
