import UIKit
import Firebase

//MARK: - ViewControllerType
enum ViewControllerType {
  case signin
  case main
}

protocol LaunchViewControllerDelegate: AnyObject {
  func presentNext(
    _ viewController: LaunchViewController,
    type: ViewControllerType
  )
}

class LaunchViewController: UIViewController {

  //MARK: - Views
  private lazy var logoImageView = NLPLogoImageView(
    frame: .zero
  )
  
  //MARK: - Properties
  weak var delegate: LaunchViewControllerDelegate?
  
  //MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
    setupLogoImageView()
    layout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkCurrentUser()
  }

  private func checkCurrentUser() {
    if Auth.auth().currentUser != nil {
      delegate?.presentNext(self, type: .main)
    } else {
      delegate?.presentNext(self, type: .signin)
    }
  }
}

//MARK: - UI Setup / Layout
extension LaunchViewController {
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setupLogoImageView() {
    view.addSubview(logoImageView)
  }
  
  private func layout() {
    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let imageSize: CGFloat = 160
    
    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(
        equalTo: safeAreaLayoutGuide.centerXAnchor
      ),
      logoImageView.centerYAnchor.constraint(
        equalTo: safeAreaLayoutGuide.centerYAnchor
      ),
      logoImageView.widthAnchor.constraint(
        equalToConstant: imageSize
      ),
      logoImageView.heightAnchor.constraint(
        equalToConstant: imageSize
      ),
    ])
  }
}
