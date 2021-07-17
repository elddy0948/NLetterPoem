import UIKit
import Firebase

class LaunchViewController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
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
            if let user = user {
                print(user)
            } else {
                self.showSignInViewController()
            }
        })
    }
    
    private func removeAuthStateChangeListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func fetchUser(with email: String) {
        DatabaseManager.shared.fetchUserInfo(with: email) { [weak self] nlpUser in
            guard let self = self else { return }
            if nlpUser != nil {
                NLPUser.shared = nlpUser
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
