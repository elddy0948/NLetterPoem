import UIKit

class MyPageViewController: UIViewController {
    
    //MARK: - Views
    private(set) var myPageCollectionView: MyPageCollectionView!
    
    //MARK: - Properties
    var user: NLPUser!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        user = NLPUser.shared!
        configure()
        configureCollectionView()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill, style: .plain, target: self, action: #selector(didTapSettingButton(_:)))
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = user.nickname
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
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        let viewController = SettingViewController()
        present(viewController, animated: true, completion: nil)
    }
}

extension MyPageViewController: UICollectionViewDelegate {
    
}

extension MyPageViewController: MyPageHeaderViewDelegate {
    func didTappedEditProfileButton(_ sender: NLPButton) {
        print("Did Tapped Edit Profile!!!!")
    }
}
