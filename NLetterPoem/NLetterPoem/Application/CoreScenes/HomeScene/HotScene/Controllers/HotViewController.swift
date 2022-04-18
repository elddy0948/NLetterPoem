import UIKit
import RxSwift
import RxCocoa

protocol HotViewControllerDelegate: AnyObject {
  func hotViewController(
    _ viewController: HotViewController,
    didSelected poemViewModel: PoemViewModel
  )
}

final class HotViewController: UIViewController {
  
  //MARK: - Views
  private lazy var homeTableView: HomeTableView = {
    let homeTableView = HomeTableView()
    
    homeTableView.delegate = self
    homeTableView.dataSource = self
    homeTableView.homeTableViewDelegate = self
    
    homeTableView.register(
      HomeTableViewCell.self,
      forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier
    )
    
    return homeTableView
  }()
  
  //MARK: - Properties
  private let hotViewModel = HotViewModel()
  private let disposeBag = DisposeBag()
  private let isLastCell = BehaviorSubject<Void>(value: ())
  private let poemsRelay = BehaviorRelay<[NLPPoem]>(value: [])
  private var isPaging = false
  private var hasNextPage = false
  
  weak var delegate: HotViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTableView()
    bindToViewModel()
    isLastCell.onNext(())
    
    let usecase = FirestoreUsecaseProvider().makePoemsUseCase()
    usecase.readPoems(query: PoemQuery(authorEmail: "howift@naver.com", createdAt: nil))
      .subscribe(onNext: { print($0) })
      .disposed(by: disposeBag)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  private func bindToViewModel() {
    let inputs = HotViewModel.Input(
      fetchNextPoems: isLastCell.asObservable()
    )
    
    let outputs = hotViewModel.transform(input: inputs)
    
    outputs.poems
      .drive(poemsRelay)
      .disposed(by: disposeBag)
  }
}

extension HotViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
//    let selectedPoemViewModel = poemsRelay.value[indexPath.row]
//
//    delegate?.hotViewController(
//      self,
//      didSelected: selectedPoemViewModel)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height
    
    if offsetY > (contentHeight - height) {
      //Call next page
      if !isPaging && hasNextPage {
        isLastCell.onNext(())
      }
    }
  }
}

extension HotViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    print(poemsRelay.value.count)
    return poemsRelay.value.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    
    let poem = poemsRelay.value[indexPath.row]

    cell.setCellData(
      shortDes: poem.content.makeShortDescription(),
      writer: poem.author,
      topic: poem.topic)
    
    return cell
  }
}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
//    fetchHotPoems()
    tableView.reloadData()
  }
}

//MARK: - UI
extension HotViewController {
  private func setupTableView() {
    view.addSubview(homeTableView)
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: NLPTabBarController.tabBarTopAnchor),
    ])
  }
}
