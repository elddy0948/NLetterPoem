import UIKit
import Firebase

protocol TodayViewControllerDelegate: AnyObject {
  func todayViewController(_ todayViewController: TodayViewController,
                           didSelected poem: NLPPoem)
}

class TodayViewController: DataLoadingViewController {
  
  //MARK: - Views
  let homeHeaderView = HomeHeaderView()
  let headerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
  let homeTableView = HomeTableView()
  var todayTableViewDataSource = TodayTableViewDataSource()
  var dispatchGroup = DispatchGroup()
  
  //MARK: - Properties
  var todayTopic: String = ""
  
  weak var delegate: TodayViewControllerDelegate?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    fetchTodayViewControllerData(homeTableView)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
}

extension TodayViewController {
  private func configureTableView() {
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
    homeTableView.backgroundColor = .systemBackground
    homeTableView.tableHeaderView = headerContainerView
    
    homeTableView.dataSource = todayTableViewDataSource
    
    homeTableView.delegate = self
    homeTableView.homeTableViewDelegate = self
    
    homeTableView.register(HomeTableViewCell.self,
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    homeTableView.register(HomeEmptyCell.self,
                           forCellReuseIdentifier: HomeEmptyCell.reuseIdentifier)
  }
}

//MARK: - Layout
extension TodayViewController {
  private func layout() {
    view.addSubview(homeTableView)
    headerContainerView.addSubview(homeHeaderView)
    
    NSLayoutConstraint.activate([
      //table view
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: NLPTabBarController.tabBarTopAnchor),
      //Header View
      homeHeaderView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
      homeHeaderView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
      homeHeaderView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
      homeHeaderView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
    ])
  }
}
