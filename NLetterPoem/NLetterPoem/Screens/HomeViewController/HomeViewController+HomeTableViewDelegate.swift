import UIKit

extension HomeViewController: HomeTableViewDelegate {
    
    func handleRefreshHomeTableView(_ tableView: HomeTableView) {
        fetchTodayTopic()
        fetchTodayPoems()
        DispatchQueue.main.async {
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
}
