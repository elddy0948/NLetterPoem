import UIKit
import RxSwift
import RxCocoa

protocol HotViewControllerDelegate: AnyObject {
  func hotViewController(_ viewController: HotViewController, didSelected poem: NLPPoem)
}

final class HotViewController: UIViewController {
  
  private var homeTableView: HomeTableView!
  private var viewModel = HotViewModel()
  private let disposeBag = DisposeBag()
  private var hotPoems = [HotPoemViewModel]() {
    didSet {
      self.homeTableView.reloadData()
    }
  }
  
  weak var delegate: HotViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configure()
    fetchHotPoems()
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
  
  private func layout() {
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: NLPTabBarController.tabBarTopAnchor),
    ])
  }
  
  private func fetchHotPoems() {
    viewModel.fetchHotPoems()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] poems in
        self?.hotPoems = poems
      }, onCompleted: { [weak self] in
        if let refreshControl = self?.homeTableView.refreshControl,
           refreshControl.isRefreshing {
          refreshControl.endRefreshing()
        }
      })
      .disposed(by: disposeBag)
  }
}

extension HotViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPoem = hotPoems[indexPath.row]
    delegate?.hotViewController(self, didSelected: selectedPoem.poem)
  }
}

extension HotViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hotPoems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    let poem = hotPoems[indexPath.row]
    cell.setCellData(shortDes: poem.shortDescription,
                     writer: poem.author,
                     topic: poem.topic)
    return cell
  }
}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    fetchHotPoems()
  }
}
