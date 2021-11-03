import UIKit
import RxSwift

class UserProfileViewController: UIViewController {
  
  private var userEmail: String?
  var userProfileCollectionView: UICollectionView?
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
                                              
  var poems = ["1", "2", "3"]
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
    //TODO: - User Info 가져오기
    userProfileService.fetchUser(with: email)
      .subscribe(onNext: { result in
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
    //TODO: - User가 작성한 시 가져오기
    userProfileService.fetchPoems(with: email)
      .subscribe(onNext: { result in
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

extension UserProfileViewController: UICollectionViewDelegate {
  
}
