import UIKit
import RxSwift

class UserProfileViewController: UIViewController {
  
  private var userEmail: String?
  var userProfileCollectionView: UICollectionView?
  private let userProfileService = UserProfileService()
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
    
    userProfileService.userViewModel
      .subscribe(onNext: { userViewModel in
        print(userViewModel)
      })
      .disposed(by: bag)
    
    guard let email = userEmail else { return }
    userProfileService.fetchUser(with: email)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  func fetchUserInfo() {
    //TODO: - User Info 가져오기
  }
  
  func fetchPoems() {
    //TODO: - User가 작성한 시 가져오기
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
