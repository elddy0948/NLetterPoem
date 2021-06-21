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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Auth.auth().currentUser?.email)
    }
    
    private func checkIsSignIn() {
        if Auth.auth().currentUser == nil {
            let viewController = UINavigationController(rootViewController: SignInViewController())
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
}

