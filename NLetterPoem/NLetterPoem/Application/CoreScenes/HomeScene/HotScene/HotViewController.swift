import UIKit
import RxSwift
import RxCocoa

protocol HotViewControllerDelegate: AnyObject {
  func hotViewController(
    _ viewController: HotViewController,
    didSelected poem: Poem
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
  private var isPaging = false
  private var isLastPage = false
  private let usecase = FirestoreUsecaseProvider().makePoemsUseCase()
  private lazy var viewModel = HotViewModel(usecase: usecase)
  weak var delegate: HotViewControllerDelegate?
  private var poems = [Poem]() {
    didSet {
      DispatchQueue.main.async {
        self.homeTableView.reloadData()
      }
    }
  }
  
  //Rx
  private let triggerSubject = PublishSubject<Void>()
  private let bag = DisposeBag()
  private let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: .global(qos: .utility)
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupTableView()
    bindToViewModel()
    triggerSubject.onNext(())
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  private func bindToViewModel() {
    let inputs = HotViewModel.Input(
      trigger: triggerSubject.asObservable()
    )
    
    let outputs = viewModel.transform(input: inputs)
    
    outputs.poems
      .observe(on: globalScheduler)
      .subscribe(onNext: { [weak self] poems in
        if poems.count < 10 {
          self?.isLastPage = true
        }
        self?.isPaging = false
        self?.poems += poems
      })
      .disposed(by: bag)
  }
}

extension HotViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let selectedPoem = poems[indexPath.row]
    delegate?.hotViewController(self, didSelected: selectedPoem)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let yOffset = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height
    
    if yOffset > (contentHeight - height) {
      if !isPaging && !isLastPage {
        isPaging = true
        triggerSubject.onNext(())
      }
    }
  }
}

extension HotViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return poems.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    
    let poem = poems[indexPath.row]

    cell.setCellData(
      shortDes: poem.content.makeShortDescription(),
      writer: poem.author,
      topic: poem.topic)
    
    return cell
  }
}

extension HotViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    viewModel.resetQuery()
    poems = []
    triggerSubject.onNext(())
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
