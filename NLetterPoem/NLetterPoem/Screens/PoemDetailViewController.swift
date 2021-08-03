import UIKit

class PoemDetailViewController: UIViewController {
    
    private(set) var detailPoemView: DetailPoemView?
    
    //MARK: - Properties
    var poem: NLPPoem?
    var fireState = false
    var currentUser: NLPUser?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let currentUser = currentUser,
              let user = NLPUser.shared else { return }
        
        if currentUser.likedPoem.count != user.likedPoem.count {
            UserDatabaseManager.shared.fetchUserInfo(with: user.email) { user in
                NLPUser.shared = user
            }
        }
    }
    
    //MARK: - Privates
    private func configure() {
        view.backgroundColor = .systemBackground
        
        currentUser = NLPUser.shared
        
        guard let poem = poem,
              let user = currentUser else { return }
        
        user.likedPoem.contains(poem.id) ? (fireState = true) : (fireState = false)
        
        detailPoemView = DetailPoemView(poem: poem, fireState: fireState)
        detailPoemView?.delegate = self
        
        self.view = detailPoemView
        
        if poem.authorEmail == user.email {
            configureRightBarButtonItem()
        }
    }
    
    private func configureRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                 target: self,
                                                 action: #selector(editButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func updateLikeCount(id: String, authorEmail: String, isIncrease: Bool) {
        PoemDatabaseManager.shared.updatePoemLikeCount(id: id,
                                                       authorEmail: authorEmail,
                                                       isIncrease: isIncrease)
    }
    
    private func updateUserLikedPoem(email: String, id: String, isRemove: Bool) {
        if isRemove {
            UserDatabaseManager.shared.removeLikedPoem(userEmail: email,
                                                       poemID: id)
        } else {
            UserDatabaseManager.shared.addLikedPoem(userEmail: email,
                                                    poemID: id)
        }
    }
    
    //MARK: -  Actions
    @objc func editButtonAction(_ sender: UIBarButtonItem) {
        let viewController = CreatePoemViewController()
        viewController.action = .edit
        viewController.editPoem = poem
        viewController.topic = poem?.topic
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}

extension PoemDetailViewController: DetailPoemViewDelegate {
    func didTappedFireButton(_ detailPoemView: DetailPoemView, _ fireButton: UIButton) {
        guard let user = currentUser,
              let poem = poem else { return }
        
        fireState.toggle()
        
        if fireState {
            user.likedPoem.append(poem.id)
            updateLikeCount(id: poem.id,
                            authorEmail: poem.authorEmail,
                            isIncrease: true)
            updateUserLikedPoem(email: user.email,
                                id: poem.id,
                                isRemove: false)
        } else {
            if let index = user.likedPoem.firstIndex(of: poem.id) {
                user.likedPoem.remove(at: index)
            }
            updateLikeCount(id: poem.id,
                            authorEmail: poem.authorEmail,
                            isIncrease: false)
            updateUserLikedPoem(email: user.email,
                                id: poem.id,
                                isRemove: true)
        }
        
        fireButton.isSelected = fireState
        fireState ? (fireButton.tintColor = .systemRed) : (fireButton.tintColor = .label)
        currentUser = user
    }
}

extension PoemDetailViewController: CreatePoemViewControllerDelegate {
    func createPoemViewController(_ viewController: CreatePoemViewController, didTapDone poem: NLPPoem) {
        self.poem = poem
        configure()
    }
}
