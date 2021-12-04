import UIKit
import RxSwift

protocol HotViewControllerDelegate: AnyObject {
  func hotViewController(
    _ viewController: HotViewController,
    didSelected poemViewModel: PoemViewModel
  )
}

final class HotViewController: UIViewController {
  
  private var homeTableView: HomeTableView!
  private var poemListViewModel = PoemListViewModel(.shared)
  private let disposeBag = DisposeBag()
  
  weak var delegate: HotViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configure()
    setupSubscription()
    fetchHotPoems()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  private func setupSubscription() {
    poemListViewModel.poemListSubject
      .subscribe(
        onNext: { [weak self] poemViewModels in
          guard let self = self else { return }
          self.homeTableView.reloadSections(
            IndexSet(integer: 0),
            with: .automatic)
          if let refreshControl = self.homeTableView.refreshControl {
            if refreshControl.isRefreshing {
              refreshControl.endRefreshing()
            }
          }
        },
        onError: { error in
        },
        onCompleted: {
        },
        onDisposed: {
        }
      )
      .disposed(by: disposeBag)
  }
  
  private func fetchHotPoems() {
    //Fetch Poems
    poemListViewModel.fetchPoems(
      order: (
        "likeCount", true
      ),
      limit: 30
    )
  }
}

extension HotViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let selectedPoemViewModel = poemListViewModel.selectedPoem(
      at: indexPath.row
    )
    delegate?.hotViewController(
      self,
      didSelected: selectedPoemViewModel)
  }
}

extension HotViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return poemListViewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    let poemViewModel = poemListViewModel.poemViewModel(
      at: indexPath.row
    )
    
    cell.setCellData(
      shortDes: poemViewModel.shortDescription,
      writer: poemViewModel.author,
      topic: poemViewModel.topic)
    
    return cell
  }
}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    fetchHotPoems()
  }
}

//MARK: - UI
extension HotViewController {
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
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: NLPTabBarController.tabBarTopAnchor),
    ])
  }
}
