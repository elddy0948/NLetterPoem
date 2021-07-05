import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Views
    private(set) var homeHeaderView: HomeHeaderView!
    private(set) var homeTableView: HomeTableView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        homeTableView = HomeTableView()
        view.backgroundColor = .systemBackground
        view = homeTableView
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        tabBarItem.title = "홈"
        tabBarItem.image = UIImage(systemName: "house.fill")
    }
    

}

extension HomeViewController: UITableViewDelegate {
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

