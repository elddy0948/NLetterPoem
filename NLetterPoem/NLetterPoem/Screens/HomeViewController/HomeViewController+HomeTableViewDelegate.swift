import UIKit

extension HomeViewController: HomeTableViewDelegate {
    
    func handleRefreshHomeTableView(_ tableView: HomeTableView) {
        fetchTodayTopic()
        DispatchQueue.main.async {
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
}
