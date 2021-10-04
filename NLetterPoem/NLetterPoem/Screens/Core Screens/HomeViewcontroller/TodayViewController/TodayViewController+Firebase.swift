import UIKit
import Firebase
extension TodayViewController {
  func fetchTodayTopic(group: DispatchGroup?) {
    DispatchQueue.global(qos: .utility).async {
      ToopicDatabaseManager.shared.read(date: Date()) { [weak self] result in
        defer {
          if let group = group {
            group.leave()
          }
        }
        guard let self = self else { return }
        switch result {
        case .success(let topic):
          self.todayTopic = topic
        case .failure(_):
          self.todayTopic = ""
        }
      }
    }
  }
  
  func fetchTodayPoems(group: DispatchGroup?) {
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.fetchTodayPoems(date: Date(), sortType: .recent) { [weak self] result in
        defer {
          if let group = group {
            group.leave()
          }
        }
        guard let self = self,
              let nlpUser = self.nlpUser else { return }
        switch result {
        case .success(let fetchedPoems):
          self.todayPoems = fetchedPoems.filter({ poem in
            !nlpUser.blockedUser.contains(poem.authorEmail)
          })
        case .failure(_):
          self.todayPoems = []
        }
      }
    }
  }
}
