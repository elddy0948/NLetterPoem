import UIKit

class PoemDetailViewController: UIViewController {
    
    private(set) var detailPoemView: DetailPoemView!
    
    //MARK: - Properties
    var poem: NLPPoem?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Privates
    private func configure() {
        view.backgroundColor = .systemBackground
        guard let poem = poem else { return }
        detailPoemView = DetailPoemView(poem: poem)
        self.view = detailPoemView
    }
}
