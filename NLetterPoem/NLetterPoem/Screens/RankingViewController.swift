import UIKit

class RankingViewController: UIViewController {
    
    //MARK: - Views
    private(set) var rankingTableView: RankingTableView!
    
    //MARK: - Properties
    private var users: [NLPUser]? {
        didSet {
            rankingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureRankingTableView()
        fetchTopTenUsers()
    }
    
    private func configureRankingTableView() {
        rankingTableView = RankingTableView()
        view.addSubview(rankingTableView)
        
        rankingTableView.register(RankingTableViewCell.self,
                                  forCellReuseIdentifier: RankingTableViewCell.reuseIdentifier)
        rankingTableView.dataSource = self
        rankingTableView.delegate = self
        
        NSLayoutConstraint.activate([
            rankingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rankingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rankingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rankingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchTopTenUsers() {
        DatabaseManager.shared.fetchTopTenUsers { users in
            self.users = users
        }
    }
}


extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = users {
            return users.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.reuseIdentifier, for: indexPath) as? RankingTableViewCell else {
            return UITableViewCell()
        }
        if let user = users?[indexPath.row] {
            cell.setCellData(with: user)
        }
        return cell
    }
}

extension RankingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = users?[indexPath.row] {
            let vc = MyPageViewController()
            vc.user = user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
