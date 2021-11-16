import UIKit
import Firebase
import RxSwift

class MyPageViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var myPageCollectionView: ProfileCollectionView?
  
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchUserProfile()
  }
  
  private func configure() {
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(didTapSettingButton(_:)))
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    myPageCollectionView = ProfileCollectionView(frame: view.frame, collectionViewLayout: layout)
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
    
    Observable.combineLatest(
      userProfileService.fetchUser(with: email),
      userProfileService.fetchPoems(with: email,
                                    sortType: .created,
                                    descending: true))
      .map({ [weak self] userResult, poemsResult -> Bool in
        guard let self = self else { return false }
        var isErrorOccured = false
        
        switch userResult {
        case .success(let userViewModel):
          self.userViewModel = userViewModel
        case .failure(_):
          isErrorOccured = true
        }
        
        switch poemsResult {
        case .success(let poemsViewModel):
          self.poemsViewModel = poemsViewModel
        case .failure(_):
          isErrorOccured = true
        }
        
        if isErrorOccured { return false }
        return true
      })
      .subscribe(on: globalQueueScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] success in
        guard let self = self else { return }
        if success {
          self.dismissLoadingView()
          self.myPageCollectionView?.reloadSections(IndexSet(integer: 0))
        } else {
          self.showAlert(title: "⚠️",
                         message: "정보를 불러오지 못했습니다",
                         action: nil)
        }
      })
      .disposed(by: bag)
  }
  
  @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
    let viewController = SettingViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MyPageViewController: MyPageHeaderViewDelegate {
  func didTappedEditProfileButton(_ sender: NLPButton) {
    guard let userViewModel = userViewModel else { return }
    let viewController = EditProfileViewController(userViewModel.user)
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
