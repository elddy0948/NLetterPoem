import UIKit
import RxSwift

final class SearchViewController: UIViewController {
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var tableView: HomeTableView!
  
  private let search = BehaviorSubject(value: "")
  private let disposeBag = DisposeBag()
  private let searchViewModel = SearchViewModel()
  
  private var resultPoems: [NLPPoem] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureTableView()
    configureSearchController()
    configureSearchBehaviorSubject()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  private func configure() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "주제 검색"
    definesPresentationContext = true
  }
  
  private func configureTableView() {
    tableView = HomeTableView()
    view.addSubview(tableView)
    
    tableView.refreshControl = nil
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemBackground
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(HomeTableViewCell.self,
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
  }
  
  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = .label
    tableView.tableHeaderView = searchController.searchBar
  }
  
  private func configureSearchBehaviorSubject() {
    search
      .filter { $0.count >= 2 }
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .flatMapLatest({ [weak self] query -> Observable<[NLPPoem]> in
        guard let self = self else { return .empty() }
        return self.searchViewModel.search(topic: query)
          .catchAndReturn([])
      })
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] poems in
        self?.resultPoems = poems
      })
      .disposed(by: disposeBag)
  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    search.onNext(searchController.searchBar.text ?? "")
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultPoems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    let poem = resultPoems[indexPath.row]
    cell.setCellData(shortDes: poem.content.makeShortDescription(),
                     writer: poem.author, topic: poem.topic)
    return cell
  }
}

extension SearchViewController {
  private func layout() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
