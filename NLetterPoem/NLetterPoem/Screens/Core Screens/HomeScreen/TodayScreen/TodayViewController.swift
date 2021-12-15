import UIKit
import Firebase
import RxSwift

protocol TodayViewControllerDelegate: AnyObject {
  func todayViewController(
    _ todayViewController: TodayViewController,
    didSelected poem: PoemViewModel)
}

class TodayViewController: DataLoadingViewController {
  
  //MARK: - Views
  let homeHeaderView = HomeHeaderView()
  let headerContainerView = UIView(
    frame: CGRect(x: 0, y: 0,
                  width: UIScreen.main.bounds.width,
                  height: 150))
  let homeTableView = HomeTableView()
  
  //MARK: - Properties
  var todayTableViewDataSource = TodayTableViewDataSource()
  let topicViewModel = TopicViewModel()
  let poemListViewModel = PoemListViewModel(.shared)
  var combineObservable: Observable<(TopicViewModel,
                                     [PoemViewModel])>
  let bag = DisposeBag()
  let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: .global(qos: .utility)
  )
  weak var delegate: TodayViewControllerDelegate?
  
  //MARK: - Initializer
  override init(nibName nibNameOrNil: String?,
                bundle nibBundleOrNil: Bundle?) {
    combineObservable = Observable
      .combineLatest(
        topicViewModel.fetchTopic(Date()),
        poemListViewModel.poemListSubject)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    combineObservable = Observable
      .combineLatest(
        topicViewModel.fetchTopic(Date()),
        poemListViewModel.poemListSubject)
    super.init(coder: coder)
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    layout()
    setupCombineSubscription()
    fetchData(homeTableView)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
//    layout()
  }
  
  private func setupCombineSubscription() {
    combineObservable
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: { [weak self] (topicViewModel, poemViewModels) in
          print(topicViewModel.topicDescription)
          print(poemViewModels)
          guard let self = self else { return }
          self.updateTableView(
            topic: topicViewModel.topicDescription,
            poemViewModels: poemViewModels
          )
          self.checkRefreshControlEnd()
        },
        onError: { error in },
        onCompleted: {},
        onDisposed: {}
      )
      .disposed(by: bag)
  }
  
  private func updateTableView(topic: String,
                               poemViewModels: [PoemViewModel]) {
    homeHeaderView.setTopic(topic)
    todayTableViewDataSource.poemViewModels = poemViewModels
    homeTableView.reloadSections(IndexSet(integer: 0),
                                 with: .automatic)
  }
  
  private func checkRefreshControlEnd() {
    if let refreshControl = homeTableView.refreshControl {
      if refreshControl.isRefreshing {
        refreshControl.endRefreshing()
      }
    }
  }
}

//MARK: - UI
extension TodayViewController {
  private func configureTableView() {
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
    homeTableView.backgroundColor = .systemBackground
    homeTableView.tableHeaderView = headerContainerView
    
    homeTableView.dataSource = todayTableViewDataSource
    
    homeTableView.delegate = self
    homeTableView.homeTableViewDelegate = self
    
    homeTableView.register(
      HomeTableViewCell.self,
      forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    
    homeTableView.register(
      HomeEmptyCell.self,
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
//      homeTableView.bottomAnchor.constraint(equalTo: NLPTabBarController.tabBarTopAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      //Header View
      homeHeaderView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
      homeHeaderView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
      homeHeaderView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
      homeHeaderView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
    ])
  }
}
