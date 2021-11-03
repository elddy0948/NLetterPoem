import UIKit
import RxSwift

class UserProfileViewController: UIViewController {
  
  //MARK: - Views
  var userProfileCollectionView: UICollectionView?
  
  //MARK: - Properties
  private var userEmail: String?
  private let userProfileService = UserProfileService()
  
  var userViewModel: ProfileUserViewModel? {
    didSet {
      self.userProfileCollectionView?.reloadData()
    }
  }
  
  var poemsViewModel: ProfilePoemsViewModel? {
    didSet {
      self.userProfileCollectionView?.reloadSections(IndexSet(integer: 0))
    }
  }
  
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
    
    guard let email = userEmail else { return }
    
    fetchUserInfo(with: email)
    fetchPoems(with: email)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  func fetchUserInfo(with email: String) {
    userProfileService.fetchUser(with: email)
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let userViewModel):
          self.userViewModel = userViewModel
        case .failure(let error):
          print(error.message)
        }
      })
      .disposed(by: bag)
  }
  
  func fetchPoems(with email: String) {
    userProfileService.fetchPoems(with: email)
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let poemsViewModel):
          self.poemsViewModel = poemsViewModel
        case .failure(let error):
          print(error.message)
        }
      })
      .disposed(by: bag)
  }
}

//MARK: - Layout
extension UserProfileViewController {
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.tintColor = .label
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
