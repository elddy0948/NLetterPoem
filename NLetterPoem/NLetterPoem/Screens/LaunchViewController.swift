import UIKit
import Firebase

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIsSignIn()
    }
    
    private func checkIsSignIn() {
        if let currentUser = Auth.auth().currentUser {
            guard let email = currentUser.email else { return }
            fetchUser(with: email)
        } else {
            showSignInViewController()
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
        let viewController = UINavigationController(rootViewController: SignInViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
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
