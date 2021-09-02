import UIKit
import Firebase

class HomeViewController: UIViewController {
  
  //MARK: - Views
  private(set) var homeHeaderView: HomeHeaderView!
  private(set) var homeTableView: HomeTableView!
  private(set) var rightBarButtonItem: UIBarButtonItem!
  
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
  
  var user: User?
  
  private var handler: AuthStateDidChangeListenerHandle?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRightBarButtonItem()
    configure()
    configureHeaderView()
    fetchTodayTopic()
    fetchTodayPoems()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
        guard let self = self,
              let user = user else { return }
        self.user = user
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
    
    homeTableView.register(HomeTableViewCell.self,
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    homeTableView.register(HomeEmptyCell.self,
                           forCellReuseIdentifier: HomeEmptyCell.reuseIdentifier)
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
    DispatchQueue.global(qos: .utility).async {
      ToopicDatabaseManager.shared.read(date: Date()) { [weak self] result in
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
  
  func fetchTodayPoems() {
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.fetchTodayPoems(date: Date(), sortType: .recent) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let fetchedPoems):
          self.todayPoems = fetchedPoems
        case .failure(_):
          self.todayPoems = []
        }
      }
    }
  }
  
  func updateTableViewContents() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.homeHeaderView.setTopic(self.todayTopic ?? "")
      self.homeTableView.reloadData()
    }
  }
  
  //MARK: - Actions
  @objc func didTappedAddButton(_ sender: UIBarButtonItem) {
    let viewController = CreateTopicViewController()
    viewController.user = user
    let createTopicNavigationController = UINavigationController(rootViewController: viewController)
    createTopicNavigationController.modalPresentationStyle = .fullScreen
    createTopicNavigationController.navigationBar.tintColor = .label
    present(createTopicNavigationController, animated: true, completion: nil)
  }
}
