import UIKit
import RxSwift

class UserProfileViewController: DataLoadingViewController {
  
  //MARK: - Views
  var userProfileCollectionView: UICollectionView?
  
  //MARK: - Properties
  private var userEmail: String?
  private let userProfileService = UserProfileService()
  private let globalQueueScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .utility))
  
  var userViewModel: ProfileUserViewModel?
  var poemsViewModel: ProfilePoemsViewModel?
  
  private let bag = DisposeBag()
  
  //MARK: - Initializer
  init(userEmail: String) {
    super.init(nibName: nil, bundle: nil)
    self.userEmail = userEmail
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureCollectionView()
    layout()
    
    guard let email = userEmail else { return }
    fetchUserProfileInformation(with: email)
  }
  
  func fetchUserProfileInformation(with email: String) {
    showLoadingView()
    Observable
      .combineLatest(userProfileService.fetchUser(with: email),
                     userProfileService.fetchPoems(with: email,
                                                   sortType: .created,
                                                   descending: true)) { userResults, poemsResult in
        switch userResults {
        case .success(let userViewModel):
          self.userViewModel = userViewModel
        case .failure(let error):
          print(error.message)
        }
        
        switch poemsResult {
        case .success(let poemsViewModel):
          self.poemsViewModel = poemsViewModel
        case .failure(let error):
          print(error.message)
        }
      }.subscribe(on: globalQueueScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe({ [weak self] _ in
        self?.dismissLoadingView()
        self?.userProfileCollectionView?.reloadSections(IndexSet(integer: 0))
      }).disposed(by: bag)
  }
}

//MARK: - Layout
extension UserProfileViewController {
  func configureViewController() {
    view.backgroundColor = .systemBackground
  }
  
  func configureCollectionView() {
    userProfileCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: ProfileCollectionHelper.createThreeColumnFlowLayout(in: view))
    guard let userProfileCollectionView = userProfileCollectionView else { return }
    
    userProfileCollectionView.backgroundColor = .systemBackground
    userProfileCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    userProfileCollectionView.register(MyPageCollectionViewCell.self,
                                       forCellWithReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier)
    userProfileCollectionView.register(UserProfileHeaderView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: UserProfileHeaderView.reuseIdentifier)
    userProfileCollectionView.delegate = self
    userProfileCollectionView.dataSource = self
  }
  
  func layout() {
    guard let userProfileCollectionView = userProfileCollectionView else { return }
    view.addSubview(userProfileCollectionView)
    
    NSLayoutConstraint.activate([
      userProfileCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      userProfileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      userProfileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      userProfileCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
