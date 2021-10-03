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
  
  func createStateChangeListener() {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
        guard let self = self,
              let user = user,
              let email = user.email else { return }
        UserDatabaseManager.shared.read(email) { result in
          switch result {
          case .success(let user):
            self.nlpUser = user
          case .failure(let error):
            debugPrint(error.message)
          }
        }
      }
    }
  }
  
  func checkUserDidWritePoemToday(with email: String?) {
    showLoadingView()
    guard let email = email else { return }
    DispatchQueue.global(qos: .userInitiated).async {
      PoemDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        self.dismissLoadingView()
        switch result {
        case .success(_):
          let viewController = CantCreatePoemViewController()
          viewController.user = self.nlpUser
          self.createNavigationController(rootVC: viewController)
        case .failure(_):
          let viewController = CreateTopicViewController()
          viewController.user = self.nlpUser
          self.createNavigationController(rootVC: viewController)
        }
      }
    }
  }
}
