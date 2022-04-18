import UIKit
import Firebase
import RxSwift

class MyPageViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var myPageCollectionView: ProfileCollectionView?
  
  //MARK: - Properties
  private let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: DispatchQueue.global(qos: .utility)
  )
  private let bag = DisposeBag()
  
  var userViewModel = UserViewModel()
  var poemListViewModel = PoemListViewModel(.shared)
  lazy var combineObservable: Observable<(
    NLPUser,
    [PoemViewModel])> = {
    return Observable.combineLatest(
      userViewModel.userSubject,
      poemListViewModel.poemListSubject)
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureCollectionView()
    setupSubscription()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchUserProfile()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    dismissLoadingView()
  }
  
  private func setupSubscription() {
    combineObservable
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
      onNext: { [weak self] (user, poemViewModels) in
        self?.dismissLoadingView()
        guard let self = self else { return }
        self.myPageCollectionView?.reloadSections(
          IndexSet(integer: 0)
        )
      },
      onError: { error in },
      onCompleted: { },
      onDisposed: { }
    ).disposed(by: bag)
  }
  
  private func fetchUserProfile() {
    guard let currentUser = Auth.auth().currentUser,
          let email = currentUser.email else { return }
    
    showLoadingView()
    userViewModel.fetchUser(email: email)
    poemListViewModel.fetchPoems(email)
  }
  
  @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
    let viewController = SettingViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MyPageViewController: MyPageHeaderViewDelegate {
  func didTappedEditProfileButton(_ sender: NLPButton) {
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

//MARK: - UI
extension MyPageViewController {
  private func configure() {
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: SFSymbols.gearShapeFill,
      style: .plain,
      target: self,
      action: #selector(didTapSettingButton(_:)))
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    myPageCollectionView = ProfileCollectionView(frame: view.frame, collectionViewLayout: layout)
    guard let myPageCollectionView = myPageCollectionView else { return }
    
    view.addSubview(myPageCollectionView)
    myPageCollectionView.register(
      MyPageCollectionViewCell.self,
      forCellWithReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier)
    myPageCollectionView.register(
      MyPageHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MyPageHeaderView.reuseIdentifier)
    myPageCollectionView.delegate = self
    myPageCollectionView.dataSource = self
  }
}
