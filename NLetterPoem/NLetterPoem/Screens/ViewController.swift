import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIsSignIn()
    }
    
    private func checkIsSignIn() {
        if Auth.auth().currentUser == nil {
            let viewController = UINavigationController(rootViewController: SignInViewController())
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
}

