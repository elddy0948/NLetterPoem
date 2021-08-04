import UIKit

class CreateTopicViewController: UIViewController {
    
    //MARK: - Views
    private(set) var createTopicView: CreateTopicView!
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCreateTopicView()
    }
    
    private func configureCreateTopicView() {
        createTopicView = CreateTopicView()
        self.view = createTopicView
    }
}
