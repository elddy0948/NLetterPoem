import UIKit
import Firebase

class MyPageViewController: UIViewController {
    
    //MARK: - Views
    private(set) var myPageCollectionView: MyPageCollectionView!
    
    //MARK: - Properties
    var user: NLPUser? {
        didSet {
            navigationItem.title = user?.nickname
            myPageCollectionView.reloadData()
            fetchPoems(with: user?.email)
        }
    }
    
    var poems: [NLPPoem]? {
        didSet {
            myPageCollectionView.reloadData()
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
        fetchCurrentUser()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill, style: .plain, target: self, action: #selector(didTapSettingButton(_:)))
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        myPageCollectionView = MyPageCollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(myPageCollectionView)
        
        myPageCollectionView.register(MyPageCollectionViewCell.self,
                                      forCellWithReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier)
        myPageCollectionView.register(MyPageHeaderView.self,
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                      withReuseIdentifier: MyPageHeaderView.reuseIdentifier)
        
        myPageCollectionView.delegate = self
        myPageCollectionView.dataSource = self
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else { return }
        
        DatabaseManager.shared.fetchUserInfo(with: email) { [weak self] user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    private func fetchPoems(with email: String?) {
        guard let email = email else { return }
        DatabaseManager.shared.fetchUserPoems(userEmail: email) { [weak self] poems in
            guard let self = self else { return }
            self.poems = poems
        }
    }
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        let viewController = SettingViewController()
        present(viewController, animated: true, completion: nil)
    }
}

extension MyPageViewController: UICollectionViewDelegate {
    
}

extension MyPageViewController: MyPageHeaderViewDelegate {
    func didTappedEditProfileButton(_ sender: NLPButton) {
        let viewController = EditProfileViewController()
        viewController.user = user
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
