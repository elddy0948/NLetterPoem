import UIKit

class PoemDetailViewController: UIViewController {
    
    private(set) var detailPoemView: DetailPoemView!
    
    //MARK: - Properties
    var poem: NLPPoem?
    var fireState = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let user = NLPUser.shared else { return }
        DatabaseManager.shared.updateUser(with: user) { _ in }
    }
    
    //MARK: - Privates
    private func configure() {
        view.backgroundColor = .systemBackground
        
        guard let poem = poem,
              let user = NLPUser.shared else { return }
        fireState = false
        
        if user.likedPoem.contains(poem.id) {
            fireState = true
        }
        
        detailPoemView = DetailPoemView(poem: poem, fireState: fireState)
        detailPoemView.delegate = self
        
        self.view = detailPoemView
    }
    
    private func updateLikeCount(id: String, isIncrease: Bool) {
        DatabaseManager.shared.updatePoemLikeCount(id: id, isIncrease: isIncrease)
    }
}

extension PoemDetailViewController: DetailPoemViewDelegate {
    func didTappedFireButton(_ detailPoemView: DetailPoemView, _ fireButton: UIButton) {
        guard let user = NLPUser.shared,
              let poem = poem else { return }
        
        fireState.toggle()
        
        if fireState {
            updateLikeCount(id: poem.id, isIncrease: true)
            user.likedPoem.append(poem.id)
        } else {
            if let index = user.likedPoem.firstIndex(of: poem.id) {
                updateLikeCount(id: poem.id, isIncrease: false)
                user.likedPoem.remove(at: index)
            }
        }
        
        fireButton.isSelected = fireState
        fireState ? (fireButton.tintColor = .systemRed) : (fireButton.tintColor = .label)
    }
}
