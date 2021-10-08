import UIKit
import Firebase

protocol TodayViewControllerDelegate: AnyObject {
  func todayViewController(_ todayViewController: TodayViewController, didSelected poem: NLPPoem)
}

class TodayViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var homeHeaderView: HomeHeaderView!
  private(set) var homeTableView: HomeTableView!
  private var headerContainerView: UIView!
  
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
  
  var nlpUser: NLPUser? = HomeViewController.nlpUser {
    didSet {
      fetchTodayTopic(group: nil)
      fetchTodayPoems(group: nil)
    }
  }
  
  weak var delegate: TodayViewControllerDelegate?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureHeaderView()
    nlpUser = HomeViewController.nlpUser
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  private func configure() {
    homeTableView = HomeTableView()
    view.addSubview(homeTableView)
    
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
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
    headerContainerView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: screenWidth, height: 150))
    homeHeaderView = HomeHeaderView()
    
    headerContainerView.addSubview(homeHeaderView)
    homeTableView.tableHeaderView = headerContainerView
  }
  
  func updateTableViewContents() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.homeHeaderView.setTopic(self.todayTopic ?? "")
      self.homeTableView.reloadData()
    }
  }
}

//MARK: - Layout
extension TodayViewController {
  private func layout() {
    NSLayoutConstraint.activate([
      //Header View
      homeHeaderView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
      homeHeaderView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
      homeHeaderView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
      homeHeaderView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
      
      //Table view
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
