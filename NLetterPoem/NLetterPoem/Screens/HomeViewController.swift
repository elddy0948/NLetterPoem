import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Views
    private(set) var homeHeaderView: HomeHeaderView!
    private(set) var homeTableView: HomeTableView!
    
    //MARK: - Properties
    private var todayTopic: String! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.homeHeaderView.setTopic(self.todayTopic)
                self.homeTableView.reloadData()
            }
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureHeaderView()
        fetchTodayTopic()
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
    
    private func configureHeaderView() {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 8
        let containerView = UIView(frame: CGRect(x: 0, y: 0,
                                                 width: screenWidth, height: 200))
        homeHeaderView = HomeHeaderView()
        containerView.addSubview(homeHeaderView)
        
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                constant: padding),
            homeHeaderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                    constant: padding),
            homeHeaderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                     constant: -padding),
            homeHeaderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                   constant: -padding),
        ])
        
        homeTableView.tableHeaderView = containerView
    }
    
    private func fetchTodayTopic() {
        DatabaseManager.shared.fetchTodayTopic(date: Date()) { [weak self] topic in
            guard let self = self else { return }
            guard let topic = topic else {
                self.todayTopic = ""
                return
            }
            self.todayTopic = topic
        }
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

