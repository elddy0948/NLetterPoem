import UIKit
import Firebase

class LaunchViewController: UIViewController {
  
  private var handle: AuthStateDidChangeListenerHandle?
  
  private(set) var logoImageView: NLPLogoImageView!
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = true
    configureLogoImageView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureAuthStateChangeListener()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeAuthStateChangeListener()
  }
  
  private func configureAuthStateChangeListener() {
    handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
      guard let self = self else { return }
      if let userEmail = user?.email {
        self.checkIfUserExist(with: userEmail)
      } else {
        self.showSignInViewController()
      }
    })
  }
  
  private func configureLogoImageView() {
    let imageSize: CGFloat = 160
    logoImageView = NLPLogoImageView(frame: .zero)
    view.addSubview(logoImageView)
    
    NSLayoutConstraint.activate([
      logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: imageSize),
      logoImageView.heightAnchor.constraint(equalToConstant: imageSize),
    ])
  }
  
  private func removeAuthStateChangeListener() {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }
  
  private func checkIfUserExist(with email: String) {
    UserDatabaseManager.shared.isUserExist(with: email) { [weak self] isUserExist in
      guard let self = self else { return }
      if isUserExist == true {
        self.fetchUser(with: email)
      } else {
        try? Auth.auth().signOut()
      }
    }
  }
  
  private func fetchUser(with email: String) {
    UserDatabaseManager.shared.fetchUserInfo(with: email) { [weak self] nlpUser in
      guard let self = self else { return }
      if nlpUser != nil {
        self.dismissAndReplaceRootViewController()
      }
    }
  }
  
  private func showSignInViewController() {
    let viewController = SignInViewController()
    viewController.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(viewController, animated: false)
  }
  
  private func dismissAndReplaceRootViewController() {
    dismiss(animated: true) {
      guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
        return
      }
      window.rootViewController = NLPTabBarController()
    }
  }
}
