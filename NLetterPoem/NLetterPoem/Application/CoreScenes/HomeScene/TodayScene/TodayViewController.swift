import UIKit
import Firebase
import RxSwift

protocol TodayViewControllerDelegate: AnyObject {
  func todayViewController(
    _ todayViewController: TodayViewController,
    didSelected poem: Poem
  )
}

final class TodayViewController: DataLoadingViewController {
  
  //MARK: - Views
  private let homeTableView = HomeTableView()
  
  //MARK: - Properties
  private let triggerSubject = PublishSubject<Void>()
  private let bag = DisposeBag()
  private let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: .global(qos: .utility)
  )
  private let usecase = FirestoreUsecaseProvider().makePoemsUseCase()
  private lazy var viewModel = TodayViewModel(usecase: usecase)
  private var poems: [Poem] = [] {
    didSet {
      DispatchQueue.main.async {
        self.homeTableView.reloadData()
      }
    }
  }
  private var isPaging: Bool = false
  private var isLastPage: Bool = false
  
  weak var delegate: TodayViewControllerDelegate?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    layout()
    bindViewModel()
    triggerSubject.onNext(())
  }
  
  private func checkRefreshControlEnd() {
    DispatchQueue.main.async {
      if let refreshControl = self.homeTableView.refreshControl {
        if refreshControl.isRefreshing {
          refreshControl.endRefreshing()
        }
      }
    }
  }
  
  private func bindViewModel() {
    let inputs = TodayViewModel.Input(
      trigger: triggerSubject
    )
    
    let outputs = viewModel.transform(input: inputs)
    
    outputs.poems
      .observe(on: globalScheduler)
      .subscribe(onNext: { [weak self] poems in
        self?.checkRefreshControlEnd()
        if poems.count < 10 {
          self?.isLastPage = true
        }
        self?.isPaging = false
        self?.poems += poems
      })
      .disposed(by: bag)
  }
}

extension TodayViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return poems.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: HomeTableViewCell.reuseIdentifier,
      for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    
    let poem = poems[indexPath.row]
    cell.setCellData(
      shortDes: poem.content.makeShortDescription(),
      writer: poem.author,
      topic: poem.topic
    )
    return cell
  }
}

extension TodayViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    let selectedPoem = poems[indexPath.row]
    delegate?.todayViewController(self, didSelected: selectedPoem)
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

extension TodayViewController: HomeTableViewDelegate {
  func handleRefreshHomeTableView(_ tableView: HomeTableView) {
    viewModel.resetQuery()
    poems = []
//    homeTableView.refreshControl?.beginRefreshing()
    triggerSubject.onNext(())
  }
}

//MARK: - UI / Layout
extension TodayViewController {
  private func configureTableView() {
    homeTableView.backgroundColor = .systemBackground
    
    homeTableView.dataSource = self
    homeTableView.delegate = self
    homeTableView.homeTableViewDelegate = self
    
    homeTableView.register(
      HomeTableViewCell.self,
      forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier
    )
  }
  
  private func layout() {
    view.addSubview(homeTableView)
    
    homeTableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
