import UIKit
import Firebase
import RxSwift

extension TodayViewController {
  func fetchData(_ tableView: UITableView) {
    poemListViewModel.fetchPoems(Date())
  }
}
