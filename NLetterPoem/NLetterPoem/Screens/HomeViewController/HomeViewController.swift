import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    //MARK: - Views
    private(set) var homeHeaderView: HomeHeaderView!
    private(set) var homeTableView: HomeTableView!
    private(set) var rightBarButtonItem: UIBarButtonItem!
    var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //MARK: - Properties
    var todayTopic: String? {
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
    
    let queue = DispatchQueue(label: "com.howift.HomeQueue")
    private var handler: AuthStateDidChangeListenerHandle?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRightBarButtonItem()
        configure()
        configureHeaderView()
        homeTableView.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTodayTopic()
        fetchTodayPoems()
        
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self,
                  let user = user,
                  let email = user.email else { return }
            
            PoemDatabaseManager.shared.fetchExistPoem(email: email,
                                                      createdAt: Date()) { poem in
                if poem != nil {
                    self.rightBarButtonItem.isEnabled = false
                } else {
                    self.rightBarButtonItem.isEnabled = true
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    private func configureRightBarButtonItem() {
        rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(didTappedAddButton(_:)))
        rightBarButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configure() {
        homeTableView = HomeTableView()
        view.backgroundColor = .systemBackground
        view = homeTableView
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.homeTableViewDelegate = self
        homeTableView.clipsToBounds = false
        homeTableView.separatorStyle = .none
        
        homeTableView.register(HomeTableViewCell.self,
                               forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        homeTableView.register(HomeEmptyCell.self,
                               forCellReuseIdentifier: HomeEmptyCell.reuseIdentifier)
        
        tabBarItem.title = "홈"
        tabBarItem.image = UIImage(systemName: "house.fill")
        navigationController?.navigationBar.tintColor = .label
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
        PoemDatabaseManager.shared.fetchTodayTopic(date: Date()) { [weak self] topic in
            guard let self = self else { return }
            guard let topic = topic else {
                self.todayTopic = ""
                return
            }
            self.todayTopic = topic
        }
    }
    
    func fetchTodayPoems() {
        PoemDatabaseManager.shared.fetchTodayPoems(date: Date()) { [weak self] poems in
            guard let self = self else { return }
            self.todayPoems = poems
        }
    }
    
    func updateTableViewContents() {
        activityIndicatorView.startAnimating()
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            guard let self = self else { return }
            self.homeHeaderView.setTopic(self.todayTopic ?? "")
            self.homeTableView.reloadData()
        }
    }
    
    //MARK: - Actions
    @objc func didTappedAddButton(_ sender: UIBarButtonItem) {
        let viewController = CreateTopicViewController()
//        viewController.topic = todayTopic
        present(viewController, animated: true, completion: nil)
    }
}
