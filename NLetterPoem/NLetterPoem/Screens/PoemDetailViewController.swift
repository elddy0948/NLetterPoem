import UIKit
import Firebase

final class PoemDetailViewController: UIViewController {
    
    private(set) var detailPoemView: DetailPoemView?
    
    //MARK: - Properties
    var poem: NLPPoem? {
        didSet {
            self.detailPoemView?.updatePoem(with: poem)
        }
    }
    var fireState = false
    var currentUser: NLPUser? {
        didSet {
            self.configurePoemDetailView()
        }
    }
    var handler: AuthStateDidChangeListenerHandle?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        handler = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            guard let self = self,
                  let user = user,
                  let email = user.email else {
                return
            }
            self.configureUser(email: email)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    //MARK: - Configure Logic
    private func configurePoemDetailView() {
        guard let poem = poem,
              let user = currentUser else { return }
        
        user.likedPoem.contains(poem.id) ? (fireState = true) : (fireState = false)
        
        detailPoemView = DetailPoemView(poem: poem,
                                        fireState: fireState)
        detailPoemView?.delegate = self
        
        guard let detailPoemView = detailPoemView else { return }
        view.addSubview(detailPoemView)
        
        NSLayoutConstraint.activate([
            detailPoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailPoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailPoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailPoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        if poem.authorEmail == user.email {
            configureRightBarButtonItem()
        }
    }
    
    private func configureUser(email: String) {
        UserDatabaseManager.shared.fetchUserInfo(with: email) { [weak self] user in
            guard let self = self,
                  let user = user else {
                return
            }
            self.currentUser = user
        }
    }
    
    //MARK: - UI Logic
    private func configureRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                 target: self,
                                                 action: #selector(editButtonAction(_:)))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    //MARK: - LikeCount Logic
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

extension PoemDetailViewController: CreatePoemViewControllerDelegate {
    func createPoemViewController(_ viewController: CreatePoemViewController, didTapDone poem: NLPPoem) {
        self.poem = poem
    }
}
