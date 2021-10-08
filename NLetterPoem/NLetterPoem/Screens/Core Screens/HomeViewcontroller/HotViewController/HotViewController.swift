import UIKit
import RxSwift
import RxCocoa

final class HotViewController: UIViewController {
  
  private var homeTableView: HomeTableView!
  private var viewModel = HotViewModel()
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configure()
    
    viewModel.fetchHotPoems()
      .observe(on: MainScheduler.instance)
      .bind(to: homeTableView.rx.items(cellIdentifier: HomeTableViewCell.reuseIdentifier)) { index, viewModel, cell in
        guard let cell = cell as? HomeTableViewCell else { return }
        cell.setCellData(shortDes: viewModel.shortDescription, writer: "Writer", topic: viewModel.topic)
      }.disposed(by: disposeBag)
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
//    homeTableView.dataSource = self
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
      homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                            constant: -NLPTabBarController.tabBarHeight),
    ])
  }
}

extension HotViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }

}
//extension HotViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 0
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    return UITableViewCell()
//  }
//
//}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
  }
}
