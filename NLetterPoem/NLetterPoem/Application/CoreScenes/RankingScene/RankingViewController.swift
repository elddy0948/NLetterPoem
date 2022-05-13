import UIKit

class RankingViewController: UIViewController {
  
  //MARK: - Views
  private(set) var rankingTableView: RankingTableView!
  
  //MARK: - Properties
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureRankingTableView()
    fetchTopTenUsers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchTopTenUsers()
  }
  
  //MARK: - Privates
  private func configureRankingTableView() {
    rankingTableView = RankingTableView()
    view.addSubview(rankingTableView)
    
    rankingTableView.register(RankingTableViewCell.self,
                              forCellReuseIdentifier: RankingTableViewCell.reuseIdentifier)
    
    rankingTableView.dataSource = self
    rankingTableView.delegate = self
    
    NSLayoutConstraint.activate([
      rankingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      rankingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      rankingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      rankingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func fetchTopTenUsers() {
  }
}


extension RankingViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? RankingTableViewCell else {
      return UITableViewCell()
    }
    
    
    return cell
  }
}

extension RankingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
  }
}
