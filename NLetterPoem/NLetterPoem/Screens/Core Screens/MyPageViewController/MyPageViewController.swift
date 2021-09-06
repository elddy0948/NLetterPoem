import UIKit
import Firebase

class MyPageViewController: UIViewController {
  
  //MARK: - Views
  private(set) var myPageCollectionView: MyPageCollectionView?
  
  //MARK: - Properties
  var user: NLPUser? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {
          return
        }
        self.navigationItem.title = self.user?.nickname
      }
      myPageCollectionView?.reloadData()
      fetchPoems(with: user?.email)
    }
  }
  
  var poems: [NLPPoem]? {
    didSet {
      myPageCollectionView?.reloadData()
    }
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    
    let email: String?
    if user == nil {
      guard let currentUser = Auth.auth().currentUser,
            let currentUserEmail = currentUser.email else {
        return
      }
      email = currentUserEmail
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill,
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(didTapSettingButton(_:)))
    } else { email = user?.email }
    
    fetchCurrentUser(with: email)
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
  
  private func fetchCurrentUser(with email: String?) {
    guard let email = email else { return }
    DispatchQueue.global(qos: .utility).async {
      UserDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let user):
          self.user = user
        case .failure(let error):
          self.showAlert(title: "⚠️", message: error.message, action: nil)
        }
      }
    }
  }
  
  private func fetchPoems(with email: String?) {
    guard let email = email else { return }
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.fetchUserPoems(userEmail: email, sortType: .recent) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let fetchedPoems):
          self.poems = fetchedPoems
        case .failure(_):
          self.poems = []
        }
      }
    }
  }
  
  @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
    let viewController = SettingViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension MyPageViewController: MyPageHeaderViewDelegate {
  func didTappedEditProfileButton(_ sender: NLPButton) {
    let viewController = EditProfileViewController()
    viewController.user = user
    viewController.modalPresentationStyle = .fullScreen
    present(viewController, animated: true, completion: nil)
  }
}
