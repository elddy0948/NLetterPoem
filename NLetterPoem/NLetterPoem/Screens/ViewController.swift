import UIKit
import FirebaseAuth
import FirebaseFirestore


class ViewController: UIViewController {
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        tabBarItem.title = "홈"
        tabBarItem.image = UIImage(systemName: "house.fill")
        print("Hello \(NLPUser.shared?.email)")
    }
}

