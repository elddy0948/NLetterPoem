import UIKit
import Firebase
import RxSwift

extension TodayViewController {
  func fetchData(_ tableView: UITableView) {
    combineObservable
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] (topic, poems) in
        guard let user = HomeViewController.nlpUser else { return }
        self?.todayTopic = topic.topic
        self?.todayTableViewDataSource.poems = poems.filter({ poem in
          !user.blockedUser.contains(poem.authorEmail)
        })
        
        if let refreshControl = tableView.refreshControl {
          if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
          }
        }
        
        self?.updateTableViewContents()
      })
      .disposed(by: bag)
  }
  
  func updateTableViewContents() {
    homeHeaderView.setTopic(todayTopic)
    homeTableView.reloadData()
  }
}
