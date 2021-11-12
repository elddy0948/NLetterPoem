import UIKit
import Firebase
extension TodayViewController {
  
  func fetchTodayViewControllerData(_ tableView: UITableView) {
    dispatchGroup.enter()
    DispatchQueue.global(qos: .utility).async {
      ToopicDatabaseManager.shared.read(date: Date()) { [weak self] result in
        defer { self?.dispatchGroup.leave() }
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
      PoemDatabaseManager.shared.fetchTodayPoems(date: Date(),
                                                 sortType: .recent) { [weak self] result in
        defer { self?.dispatchGroup.leave() }
        guard let self = self,
              let nlpUser = HomeViewController.nlpUser else { return }
        switch result {
        case .success(let fetchedPoems):
          self.todayTableViewDataSource.poems = fetchedPoems.filter({ poem in
            !nlpUser.blockedUser.contains(poem.authorEmail)
          })
        case .failure(_):
          self.todayTableViewDataSource.poems = []
        }
      }
    }
    
    dispatchGroup.notify(queue: .main, execute: { [weak self] in
      guard let self = self else { return }
      self.updateTableViewContents()
      if let refreshControl = tableView.refreshControl {
        if refreshControl.isRefreshing {
          refreshControl.endRefreshing()
        }
      }
    })
  }
  
  func updateTableViewContents() {
    homeHeaderView.setTopic(todayTopic)
    homeTableView.reloadData()
  }
}
