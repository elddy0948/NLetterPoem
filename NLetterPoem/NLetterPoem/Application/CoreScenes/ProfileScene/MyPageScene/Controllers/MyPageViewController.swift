import UIKit
import Firebase
import RxSwift

final class MyPageViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var myPageCollectionView: ProfileCollectionView?
  
  //MARK: - Properties
  private let globalScheduler = ConcurrentDispatchQueueScheduler(
    queue: DispatchQueue.global(qos: .utility)
  )
  private let bag = DisposeBag()
  
//  var userViewModel = UserViewModel()
//  var poemListViewModel = PoemListViewModel(.shared)
//
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
  }
  
  private func fetchUserProfile() {
  }
  
  @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
    let viewController = SettingViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MyPageViewController: MyPageHeaderViewDelegate {
  func didTappedEditProfileButton(_ sender: NLPButton) {
  }
}

extension MyPageViewController: EditProfileViewControllerDelegate {
  func editProfileViewController(_ viewController: EditProfileViewController,
                                 didFinishEditing user: NLetterPoemUser?) {
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
