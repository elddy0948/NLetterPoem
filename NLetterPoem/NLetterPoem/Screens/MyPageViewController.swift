import UIKit

class MyPageViewController: UIViewController {
    
    //MARK: - Views
    private(set) var myPageView: MyPageView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureMyPageView()
    }
    
    private func configure() {
        tabBarItem.title = "마이페이지"
        tabBarItem.image = UIImage(systemName: SFSymbols.personFill)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SFSymbols.gearShapeFill), style: .plain, target: self, action: #selector(didTapSettingButton(_:)))
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureMyPageView() {
        myPageView = MyPageView()
        view.addSubview(myPageView)
        
        NSLayoutConstraint.activate([
            myPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myPageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPageView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        let viewController = SettingViewController()
        present(viewController, animated: true, completion: nil)
    }
}
