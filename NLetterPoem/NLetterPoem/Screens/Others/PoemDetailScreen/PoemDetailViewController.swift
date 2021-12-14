import UIKit
import Firebase
import RxSwift

final class PoemDetailViewController: DataLoadingViewController {
  
  private(set) var detailPoemView: PoemDetailView?
  
  //MARK: - Properties
  private var poemViewModel: PoemViewModel
  private let currentUserViewModel = CurrentUserViewModel.shared
  private var currentUser = NLPUser.empty {
    didSet {
      setupFireState()
    }
  }
  private let bag = DisposeBag()
  var fireState = false
  var enableAuthorButton = true
  
  //MARK: - Initializer
  init(_ poemViewModel: PoemViewModel) {
    self.poemViewModel = poemViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupPoemDetailView()
    setupUserSubscription()
    showLoadingView()
    currentUserViewModel.fetchCurrentUser(
      currentUserViewModel.email
    )
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    currentUserViewModel.fetchCurrentUser(
      currentUserViewModel.email
    )
  }
  
  private func setupUserSubscription() {
    currentUserViewModel.userSubject
      .subscribe(
        onNext: { [weak self] user in
          guard let self = self else { return }
          self.dismissLoadingView()
          self.currentUser = user
        },
        onError: { error in },
        onCompleted: {},
        onDisposed: {}
      ).disposed(by: bag)
  }
  
  //MARK: - LikeCount Logic
  private func updateLikeCount(
    id: String,
    authorEmail: String,
    isIncrease: Bool) {
      DispatchQueue.global(qos: .userInitiated).async {
        PoemDatabaseManager.shared.updateLikeCount(
          poemID: id,
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
  
  private func updateUserLikedPoem(
    email: String,
    id: String,
    isRemove: Bool) {
      DispatchQueue.global(qos: .userInitiated).async {
        if isRemove {
          UserDatabaseManager.shared.unLikedPoem(
            to: email,
            poemID: id) { _ in }
        } else {
          UserDatabaseManager.shared.likedPoem(
            to: email,
            poemID: id) { _ in }
        }
      }
    }
  
  //MARK: -  Actions
  @objc func editButtonAction(_ sender: UIBarButtonItem) {
    let alertController = configureAlertController()
    present(alertController, animated: true, completion: nil)
  }
  
  @objc func reportButtonAction(_ sender: UIBarButtonItem) {
    self.present(
      AlertControllerHelper.configureReportAlertController(
        self,
        user: currentUserViewModel.user,
        poemViewModel: poemViewModel
      ), animated: true, completion: nil)
  }
  
  private func configureAlertController() -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    )
    
    let editAction = UIAlertAction(
      title: "수정",
      style: .default
    ) { [weak self] action in
      guard let self = self else { return }
      let viewController = self.configureCreatePoemViewController()
      self.present(viewController, animated: true, completion: nil)
    }
    
    let deleteAction = UIAlertAction(
      title: "삭제",
      style: .destructive
    ) { [weak self] action in
      guard let self = self else { return }
      self.deletePoem()
      self.navigationController?.popToRootViewController(
        animated: true
      )
    }
    
    let cancelAction = UIAlertAction(
      title: "취소",
      style: .cancel) { _ in }
    
    alertController.addAction(editAction)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    return alertController
  }
  
  private func configureCreatePoemViewController() -> CreatePoemViewController {
    let viewController = CreatePoemViewController()
    let poem = poemViewModel.currentPoem
    viewController.action = .edit
    viewController.user = currentUserViewModel.user
    viewController.editPoem = poem
    viewController.topic = poem.topic
    viewController.delegate = self
    return viewController
  }
  
  private func deletePoem() {
    DispatchQueue.global(qos: .utility)
      .async { [weak self] in
        guard let self = self else { return }
        PoemDatabaseManager.shared.delete(
          self.poemViewModel.id
        ) { _ in }
        UserDatabaseManager.shared.deletePoem(
          to: self.currentUserViewModel.email,
          poemID: self.poemViewModel.id
        ) { _ in }
      }
  }
}

//MARK: - DetailPoemViewDelegate
extension PoemDetailViewController: PoemDetailViewDelegate {
  func detailPoemView(
    _ view: PoemDetailView,
    didTapAuthor author: String?
  ) {
    let email = poemViewModel.authorEmail
    let viewController = UserProfileViewController(
      userEmail: email
    )
    navigationController?.pushViewController(
      viewController,
      animated: true
    )
  }
  
  func didTappedFireButton(
    _ detailPoemView: PoemDetailView,
    _ fireButton: UIButton) {
      let user = currentUserViewModel.user
      let poem = poemViewModel.currentPoem
      
      fireState.toggle()
      if fireState {
        updateLikeCount(
          id: poem.id,
          authorEmail: poem.authorEmail,
          isIncrease: true)
        updateUserLikedPoem(
          email: user.email,
          id: poem.id,
          isRemove: false)
      } else {
        updateLikeCount(
          id: poem.id,
          authorEmail: poem.authorEmail,
          isIncrease: false)
        updateUserLikedPoem(
          email: user.email,
          id: poem.id,
          isRemove: true)
      }
      detailPoemView.fireButtonState(fireState: fireState)
    }
}

//MARK: - CreatePoemViewControllerDelegate
extension PoemDetailViewController: CreatePoemViewControllerDelegate {
  func createPoemViewController(
    _ viewController: CreatePoemViewController,
    didTapDone poem: NLPPoem) {
      self.poemViewModel = PoemViewModel(poem)
      detailPoemView?.updatePoem(
        with: poemViewModel.currentPoem
      )
    }
}

//MARK: - UI Logic
extension PoemDetailViewController {
  private func setupPoemDetailView() {
    detailPoemView = PoemDetailView(
      poemViewModel: poemViewModel,
      fireState: fireState,
      enableAuthorButton: enableAuthorButton
    )
    
    guard let detailPoemView = detailPoemView else { return }
    
    detailPoemView.delegate = self
    
    view.addSubview(detailPoemView)
    
    NSLayoutConstraint.activate([
      detailPoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailPoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      detailPoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      detailPoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func setupFireState() {
    print(currentUserViewModel.likedPoems)
    currentUserViewModel.likedPoems.contains(poemViewModel.id) ?
    (fireState = true) : (fireState = false)
    detailPoemView?.fireButtonState(fireState: fireState)
  }
  
  private func checkIsEditable() {
    let isEditable = navigationController?.viewControllers.first is MyPageViewController
    
    if (poemViewModel.authorEmail == currentUserViewModel.email) && isEditable {
      configureRightBarButtonItem(isEditable: true)
    } else {
      configureRightBarButtonItem(isEditable: false)
    }
  }
  
  private func configureRightBarButtonItem(
    isEditable: Bool) {
      let reportBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "megaphone"),
        style: .plain,
        target: self,
        action: #selector(reportButtonAction(_:))
      )
      
      navigationItem.rightBarButtonItem = reportBarButtonItem
      
      if isEditable {
        let editBarButtonItem = UIBarButtonItem(
          barButtonSystemItem: .edit,
          target: self,
          action: #selector(editButtonAction(_:))
        )
        
        navigationItem.rightBarButtonItems = [
          reportBarButtonItem,
          editBarButtonItem
        ]
      }
    }
}
