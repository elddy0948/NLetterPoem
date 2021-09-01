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
  var enableAuthorButton = true
  
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
                                    fireState: fireState,
                                    enableAuthorButton: enableAuthorButton)
    detailPoemView?.delegate = self
    
    guard let detailPoemView = detailPoemView else { return }
    view.addSubview(detailPoemView)
    
    NSLayoutConstraint.activate([
      detailPoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailPoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      detailPoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      detailPoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    //If visitor is poem's author can show 'Edit' button
    if poem.authorEmail == user.email {
      configureRightBarButtonItem()
    }
  }
  
  private func configureUser(email: String) {
    DispatchQueue.global(qos: .userInitiated).async {
      UserDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let user):
          self.currentUser = user
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      }
    }
  }
  
  //MARK: - UI Logic
  private func configureRightBarButtonItem() {
    let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                             target: self,
                                             action: #selector(editButtonAction(_:)))
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
  }
  
  
  //MARK: - LikeCount Logic
  private func updateLikeCount(id: String, authorEmail: String, isIncrease: Bool) {
    PoemDatabaseManager.shared.updatePoemLikeCount(id: id,
                                                   authorEmail: authorEmail,
                                                   isIncrease: isIncrease)
  }
  
  private func updateUserLikedPoem(email: String, id: String, isRemove: Bool) {
    if isRemove {
      DispatchQueue.global(qos: .userInteractive).async {
        UserDatabaseManager.shared.unLikedPoem(to: email, poemID: id) { _ in }
      }
    } else {
      DispatchQueue.global(qos: .userInteractive).async {
        UserDatabaseManager.shared.likedPoem(to: email, poemID: id) { _ in }
      }
    }
  }
  
  //MARK: -  Actions
  @objc func editButtonAction(_ sender: UIBarButtonItem) {
    let alertController = configureAlertController()
    present(alertController, animated: true, completion: nil)
  }
  
  private func configureAlertController() -> UIAlertController {
    let alertController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
    let editAction = UIAlertAction(title: "수정",
                                   style: .default) { [weak self] action in
      guard let self = self else { return }
      let viewController = self.configureCreatePoemViewController()
      self.present(viewController, animated: true, completion: nil)
    }
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
      guard let self = self else { return }
      //TODO: - Delete Action
      self.deletePoem()
      self.navigationController?.popToRootViewController(animated: true)
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
    
    alertController.addAction(editAction)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    return alertController
  }
  
  private func configureCreatePoemViewController() -> CreatePoemViewController {
    let viewController = CreatePoemViewController()
    viewController.action = .edit
    viewController.editPoem = self.poem
    viewController.topic = self.poem?.topic
    viewController.delegate = self
    return viewController
  }
  
  private func deletePoem() {
    guard let poem = poem,
          let currentUser = currentUser else { return }
    
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.deletePoem(poem,
                                            requester: currentUser.email) { result in
        switch result {
        case .success(let message):
          print(message)
        case .failure(let error):
          print(error.message)
        }
      }
      UserDatabaseManager.shared.deletePoem(to: currentUser.email, poemID: poem.id) { _ in }
    }
  }
}

extension PoemDetailViewController: DetailPoemViewDelegate {
  func detailPoemView(_ view: DetailPoemView,
                      didTapAuthor author: String?) {
    guard let email = poem?.authorEmail else { return }
    let viewController = MyPageViewController()
    
    DispatchQueue.global(qos: .userInitiated).async {
      UserDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let user):
          viewController.user = user
          self.navigationController?.pushViewController(viewController, animated: true)
        case .failure(let error):
          debugPrint(error.localizedDescription)
        }
      }
    }
  }
  
  func didTappedFireButton(_ detailPoemView: DetailPoemView,
                           _ fireButton: UIButton) {
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
