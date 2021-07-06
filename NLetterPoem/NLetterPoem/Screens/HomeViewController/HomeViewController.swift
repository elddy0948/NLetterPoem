import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Views
    private(set) var homeHeaderView: HomeHeaderView!
    private(set) var homeTableView: HomeTableView!
    
    //MARK: - Properties
    private var todayTopic: String! {
        didSet {
            if oldValue != todayTopic {
                updateTableViewContents()
            }
        }
    }
    
    var todayPoems: [NLPPoem]? {
        didSet {
            updateTableViewContents()
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureHeaderView()
        fetchTodayTopic()
        fetchTodayPoems()
    }

    private func configure() {
        homeTableView = HomeTableView()
        view.backgroundColor = .systemBackground
        view = homeTableView
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.homeTableViewDelegate = self
        
        homeTableView.register(HomeTableViewCell.self,
                               forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        
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
    
    func fetchTodayTopic() {
        DatabaseManager.shared.fetchTodayTopic(date: Date()) { [weak self] topic in
            guard let self = self else { return }
            guard let topic = topic else {
                self.todayTopic = ""
                return
            }
            self.todayTopic = topic
        }
    }
    
    func fetchTodayPoems() {
        DatabaseManager.shared.fetchTodayPoems(date: Date()) { [weak self] poems in
            guard let self = self else { return }
            self.todayPoems = poems
        }
    }
    
    func updateTableViewContents() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.homeHeaderView.setTopic(self.todayTopic)
            self.homeTableView.reloadData()
        }
    }
}



