import UIKit
import Firebase
import RxSwift

class MyPageViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var myPageCollectionView: MyPageCollectionView?
  
  //MARK: - Properties
  private let userProfileService = UserProfileService()
  private let globalQueueScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .utility))
  private let bag = DisposeBag()
  var userViewModel: ProfileUserViewModel?
  var poemsViewModel: ProfilePoemsViewModel?
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureCollectionView()
    fetchUserProfile()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(didTapSettingButton(_:)))
  }
  
  private func configure() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.tintColor = .label
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()

    myPageCollectionView = MyPageCollectionView(frame: view.frame, collectionViewLayout: layout)
    guard let myPageCollectionView = myPageCollectionView else { return }

    view.addSubview(myPageCollectionView)
    myPageCollectionView.register(MyPageCollectionViewCell.self,
                                  forCellWithReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier)
    myPageCollectionView.register(MyPageHeaderView.self,
                                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                  withReuseIdentifier: MyPageHeaderView.reuseIdentifier)
    
    myPageCollectionView.delegate = self
    myPageCollectionView.dataSource = self
  }
  
  private func fetchUserProfile() {
    guard let currentUser = Auth.auth().currentUser,
          let email = currentUser.email else { return }
    
    showLoadingView()
    Observable
      .combineLatest(userProfileService.fetchUser(with: email),
                     userProfileService.fetchPoems(with: email)) { userResults, poemsResult in
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
        self?.myPageCollectionView?.reloadSections(IndexSet(integer: 0))
      }).disposed(by: bag)
  }
  
  @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
    let viewController = SettingViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MyPageViewController: MyPageHeaderViewDelegate {
  func didTappedEditProfileButton(_ sender: NLPButton) {
    let viewController = EditProfileViewController()
    viewController.user = userViewModel?.user
    viewController.modalPresentationStyle = .fullScreen
    viewController.delegate = self
    present(viewController, animated: true, completion: nil)
  }
}

extension MyPageViewController: EditProfileViewControllerDelegate {
  func editProfileViewController(_ viewController: EditProfileViewController,
                                 didFinishEditing user: NLPUser?) {
    fetchUserProfile()
  }
}
