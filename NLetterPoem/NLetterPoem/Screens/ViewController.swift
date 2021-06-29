import UIKit
import FirebaseAuth
import FirebaseFirestore


class ViewController: UIViewController {
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        createMockPoem()
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        tabBarItem.title = "홈"
        tabBarItem.image = UIImage(systemName: "house.fill")
        print("Hello \(NLPUser.shared?.email)")
    }
}

