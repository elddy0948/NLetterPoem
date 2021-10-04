import UIKit
import Firebase

class TodayViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var homeHeaderView: HomeHeaderView!
  private(set) var homeTableView: HomeTableView!
  
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
  
  var nlpUser: NLPUser? {
    didSet {
      fetchTodayTopic(group: nil)
      fetchTodayPoems(group: nil)
    }
  }
  
  var handler: AuthStateDidChangeListenerHandle?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    configure()
    configureHeaderView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    createStateChangeListener()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let handler = handler {
      Auth.auth().removeStateDidChangeListener(handler)
    }
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
  
  private func configureHeaderView() {
    let screenWidth = UIScreen.main.bounds.width
    let padding: CGFloat = 8
    let containerView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: screenWidth, height: 150))
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
  
  func updateTableViewContents() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.homeHeaderView.setTopic(self.todayTopic ?? "")
      self.homeTableView.reloadData()
    }
  }
  
  func createNavigationController(rootVC viewController: CreatorViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.navigationBar.tintColor = .label
    present(navigationController, animated: true, completion: nil)
  }
}
