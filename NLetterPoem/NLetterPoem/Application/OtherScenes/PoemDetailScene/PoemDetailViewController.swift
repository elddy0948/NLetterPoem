import UIKit
import Firebase
import RxSwift

protocol PoemDetailViewControllerDelegate: AnyObject {
  
}

final class PoemDetailViewController: DataLoadingViewController {
  
  private(set) var detailPoemView: PoemDetailView?
  
  //MARK: - Properties
  private var poem: Poem?
  private let currentUser = Auth.auth().currentUser
  private let bag = DisposeBag()
  var fireState = false
  var enableAuthorButton = true
  private let globalScheduler = SerialDispatchQueueScheduler(
    qos: .utility
  )
  
  //MARK: - Initializer
  init(poem: Poem?) {
    self.poem = poem
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
    checkIsEditable()
  }
  
  //MARK: - LikeCount Logic
  private func updateLikeCount(
    id: String,
    authorEmail: String,
    isIncrease: Bool) {
    }
  
  private func updateUserLikedPoem(
    email: String,
    id: String,
    isRemove: Bool) {
      DispatchQueue.global(qos: .userInitiated).async {
        if isRemove {
        } else {
        }
      }
    }
  
  //MARK: -  Actions
  @objc func editButtonAction(_ sender: UIBarButtonItem) {
    let alertController = configureAlertController()
    present(alertController, animated: true, completion: nil)
  }
  
  @objc func reportButtonAction(_ sender: UIBarButtonItem) {
    guard let currentUser = currentUser,
          let email = currentUser.email else { return }
    self.present(
      AlertControllerHelper.configureReportAlertController(
        self,
        userEmail: email,
        poem: poem
      ), animated: true, completion: nil
    )
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
      self.presentCreatePoemViewController()
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
  
  private func presentCreatePoemViewController() {
    guard let poem = poem else { return }
    
    let viewController = CreatePoemViewController(
      NLetterTopic(topic: poem.topic),
      poem: poem
    )
    viewController.delegate = self
    
    present(viewController, animated: true)
  }
  
  private func deletePoem() {
    //    guard let user = user else { return }
  }
}

//MARK: - DetailPoemViewDelegate
extension PoemDetailViewController: PoemDetailViewDelegate {
  func detailPoemView(
    _ view: PoemDetailView,
    didTapAuthor author: String?
  ) {
    //    let email = poemViewModel.authorEmail
    //    let viewController = UserProfileViewController(
    //      userEmail: email
    //    )
    //    navigationController?.pushViewController(
    //      viewController,
    //      animated: true
    //    )
  }
  
  func didTappedFireButton(
    _ detailPoemView: PoemDetailView,
    _ fireButton: UIButton
  ) {
  }
}

//MARK: - CreatePoemViewControllerDelegate
extension PoemDetailViewController: CreatePoemViewControllerDelegate {
  func createPoemViewController(
    _ viewController: CreatePoemViewController,
    didTapDone poem: Poem) {
      
    }
}

//MARK: - UI Logic
extension PoemDetailViewController {
  private func setupPoemDetailView() {
    guard let poem = poem else { return }
    detailPoemView = PoemDetailView(
      poem: poem,
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
    //    guard let user = user else { return }
    //    user.likedPoem.contains(
    //      poemViewModel.id
    //    ) ? (fireState = true) : (fireState = false)
    //    detailPoemView?.fireButtonState(fireState: fireState)
  }
  
  private func checkIsEditable() {
    //    guard let user = user else { return }
    //    let isEditable = navigationController?.viewControllers.first is MyPageViewController
    //
    //    if (poemViewModel.authorEmail == user.email) && isEditable {
    //      configureRightBarButtonItem(isEditable: true)
    //    } else {
    //      configureRightBarButtonItem(isEditable: false)
    //    }
  }
  
  private func configureRightBarButtonItem(
    isEditable: Bool
  ) {
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
