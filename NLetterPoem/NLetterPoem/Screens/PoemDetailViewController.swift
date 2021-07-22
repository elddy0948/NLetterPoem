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
    
    private func updateLikeCount(id: String, authorEmail: String, isIncrease: Bool) {
        PoemDatabaseManager.shared.updatePoemLikeCount(id: id,
                                                       authorEmail: authorEmail,
                                                       isIncrease: isIncrease)
    }
    
    private func updateUserLikedPoem(email: String, id: String, isRemove: Bool) {
        if isRemove {
            UserDatabaseManager.shared.removeLikedPoem(userEmail: email, poemID: id)
        } else {
            UserDatabaseManager.shared.addLikedPoem(userEmail: email, poemID: id)
        }
    }
}

extension PoemDetailViewController: DetailPoemViewDelegate {
    func didTappedFireButton(_ detailPoemView: DetailPoemView, _ fireButton: UIButton) {
        guard let user = NLPUser.shared,
              let poem = poem else { return }
        
        fireState.toggle()
        
        if fireState {
            updateLikeCount(id: poem.id,
                            authorEmail: poem.authorEmail,
                            isIncrease: true)
            updateUserLikedPoem(email: user.email,
                                id: poem.id,
                                isRemove: false)
        } else {
            updateLikeCount(id: poem.id,
                            authorEmail: poem.authorEmail,
                            isIncrease: false)
            updateUserLikedPoem(email: user.email,
                                id: poem.id,
                                isRemove: true)
        }
        
        fireButton.isSelected = fireState
        fireState ? (fireButton.tintColor = .systemRed) : (fireButton.tintColor = .label)
    }
}
