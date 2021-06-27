import UIKit

class MyPageViewController: UIViewController {
    
    //MARK: - Views
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private(set) var myPageView: MyPageView!
    private(set) var participationView: NLPProfileCardView!
    private(set) var firstPlaceView: NLPProfileCardView!
    private(set) var secondPlaceView: NLPProfileCardView!
    private(set) var thirdPlaceView: NLPProfileCardView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureScrollView()
        configureMyPageView()
        configureParticipationView()
        configureFirstPlaceView()
        configureSecondPlaceView()
        configureThirdPlaceView()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.gearShapeFill, style: .plain, target: self, action: #selector(didTapSettingButton(_:)))
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 850)
        ])
    }
    
    private func configureMyPageView() {
        myPageView = MyPageView()
        contentView.addSubview(myPageView)
        
        NSLayoutConstraint.activate([
            myPageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            myPageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myPageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myPageView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func configureParticipationView() {
        let padding: CGFloat = 16
        participationView = NLPProfileCardView(type: .participation)
        contentView.addSubview(participationView)
        
        NSLayoutConstraint.activate([
            participationView.topAnchor.constraint(equalTo: myPageView.bottomAnchor, constant: padding),
            participationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            participationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            participationView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureFirstPlaceView() {
        let padding: CGFloat = 16
        firstPlaceView = NLPProfileCardView(type: .firstPlace)
        contentView.addSubview(firstPlaceView)
        
        NSLayoutConstraint.activate([
            firstPlaceView.topAnchor.constraint(equalTo: participationView.bottomAnchor, constant: padding),
            firstPlaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            firstPlaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            firstPlaceView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureSecondPlaceView() {
        let padding: CGFloat = 16
        secondPlaceView = NLPProfileCardView(type: .secondPlace)
        contentView.addSubview(secondPlaceView)
        
        NSLayoutConstraint.activate([
            secondPlaceView.topAnchor.constraint(equalTo: firstPlaceView.bottomAnchor, constant: padding),
            secondPlaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            secondPlaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            secondPlaceView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureThirdPlaceView() {
        let padding: CGFloat = 16
        thirdPlaceView = NLPProfileCardView(type: .thirdPlace)
        contentView.addSubview(thirdPlaceView)
        
        NSLayoutConstraint.activate([
            thirdPlaceView.topAnchor.constraint(equalTo: secondPlaceView.bottomAnchor, constant: padding),
            thirdPlaceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            thirdPlaceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            thirdPlaceView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func didTapSettingButton(_ sender: UIBarButtonItem) {
        let viewController = SettingViewController()
        present(viewController, animated: true, completion: nil)
    }
}
