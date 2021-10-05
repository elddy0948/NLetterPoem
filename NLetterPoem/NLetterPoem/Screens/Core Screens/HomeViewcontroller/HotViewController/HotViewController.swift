import UIKit

final class HotViewController: UIViewController {
  
  private var homeTableView = HomeTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
  }
  private func configure() {
    homeTableView = HomeTableView()
    view = homeTableView
    
    homeTableView.backgroundColor = .systemBackground
    homeTableView.delegate = self
    homeTableView.dataSource = self
    homeTableView.homeTableViewDelegate = self
    
    homeTableView.register(HomeTableViewCell.self,
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    homeTableView.register(HomeEmptyCell.self,
                           forCellReuseIdentifier: HomeEmptyCell.reuseIdentifier)
    navigationController?.navigationBar.tintColor = .label
  }
}

extension HotViewController: UITableViewDelegate {
  
}
extension HotViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }

}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
  }
}
