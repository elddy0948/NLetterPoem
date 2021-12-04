import UIKit
import Firebase

final class PoemDetailViewController: UIViewController {
  
  private(set) var detailPoemView: PoemDetailView?
  
  //MARK: - Properties
  private var poem: NLPPoem?
  private var currentUser: NLPUser?
  var fireState = false
  var enableAuthorButton = true
  
  //MARK: - Initializer
  init(_ poem: NLPPoem, _ currentUser: NLPUser) {
    super.init(nibName: nil, bundle: nil)
    self.poem = poem
    self.currentUser = currentUser
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configurePoemDetailView()
  }
  
  //MARK: - Configure Logic
  private func configurePoemDetailView() {
    guard let poem = poem,
          let user = currentUser else { return }
    
    user.likedPoem.contains(poem.id) ? (fireState = true) : (fireState = false)
    
    detailPoemView = PoemDetailView(poem: poem,
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
    
    let isEditable = navigationController?.viewControllers.first is MyPageViewController
    
    if (poem.authorEmail == user.email) && isEditable {
      configureRightBarButtonItem(isEditable: true)
    } else {
      configureRightBarButtonItem(isEditable: false)
    }
  }
  
  //MARK: - UI Logic
  private func configureRightBarButtonItem(isEditable: Bool) {
    let reportBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "megaphone"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(reportButtonAction(_:)))
    navigationItem.rightBarButtonItem = reportBarButtonItem
    if isEditable {
      let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                             target: self,
                                             action: #selector(editButtonAction(_:)))
      navigationItem.rightBarButtonItems?.append(editBarButtonItem)
    }
  }
  
  //MARK: - LikeCount Logic
  private func updateLikeCount(id: String, authorEmail: String, isIncrease: Bool) {
    DispatchQueue.global(qos: .userInitiated).async {
      PoemDatabaseManager.shared.updateLikeCount(poemID: id,
                                                 author: authorEmail,
                                                 isIncrease: isIncrease) { error in
        if error != nil {
          self.showAlert(title: "⚠️", message: "문제가 발생했습니다!\n다시 시도해주세요!") { _ in
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  private func updateUserLikedPoem(email: String, id: String, isRemove: Bool) {
    DispatchQueue.global(qos: .userInitiated).async {
      if isRemove {
        UserDatabaseManager.shared.unLikedPoem(to: email, poemID: id) { _ in }
      } else {
        UserDatabaseManager.shared.likedPoem(to: email, poemID: id) { _ in }
      }
    }
  }
  
  //MARK: -  Actions
  @objc func editButtonAction(_ sender: UIBarButtonItem) {
    let alertController = configureAlertController()
    present(alertController, animated: true, completion: nil)
  }
  
  @objc func reportButtonAction(_ sender: UIBarButtonItem) {
    self.present(configureReportAlertController(), animated: true, completion: nil)
  }
  
  private func configureReportAlertController() -> UIAlertController {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let blockAction = UIAlertAction(title: "사용자 차단하기", style: .destructive, handler: { [weak self] action in
      guard let self = self,
            let currentUser = self.currentUser,
            let poem = self.poem else { return }
      UserDatabaseManager.shared.block(userEmail: currentUser.email,
                                       blockEmail: poem.authorEmail) { result in
        switch result {
        case .success(let message):
          self.showAlert(title: "✅", message: message, action: nil)
        case .failure(let error):
          self.showAlert(title: "⚠️", message: error.message, action: nil)
        }
      }
    })
    let reportAction = UIAlertAction(title: "신고하기", style: .destructive, handler: { [weak self] action in
      guard let self = self,
            let currentUser = self.currentUser,
            let poem = self.poem else { return }
      ReportDatabaseManager.shared.create(user: currentUser.email, reportedPoem: poem, reportMessage: "신고!") { result in
        switch result {
        case .success(let message):
          self.showAlert(title: "✅", message: message, action: nil)
        case .failure(let error):
          self.showAlert(title: "⚠️", message: error.message, action: nil)
        }
      }
    })
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertController.addAction(blockAction)
    alertController.addAction(reportAction)
    alertController.addAction(cancelAction)
    return alertController
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
    viewController.user = currentUser
    viewController.editPoem = self.poem
    viewController.topic = self.poem?.topic
    viewController.delegate = self
    return viewController
  }
  
  private func deletePoem() {
    guard let poem = poem,
          let currentUser = currentUser else { return }
    
    DispatchQueue.global(qos: .utility).async {
      PoemDatabaseManager.shared.delete(poem.id) { _ in }
      UserDatabaseManager.shared.deletePoem(to: currentUser.email, poemID: poem.id) { _ in }
    }
  }
}

//MARK: - DetailPoemViewDelegate
extension PoemDetailViewController: PoemDetailViewDelegate {
  func detailPoemView(_ view: PoemDetailView,
                      didTapAuthor author: String?) {
    guard let email = poem?.authorEmail else { return }
    let viewController = UserProfileViewController(userEmail: email)
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  func didTappedFireButton(_ detailPoemView: PoemDetailView,
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

//MARK: - CreatePoemViewControllerDelegate
extension PoemDetailViewController: CreatePoemViewControllerDelegate {
  func createPoemViewController(_ viewController: CreatePoemViewController,
                                didTapDone poem: NLPPoem) {
    self.poem = poem
    detailPoemView?.updatePoem(with: poem)
  }
}