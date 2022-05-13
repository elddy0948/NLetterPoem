import UIKit
import Firebase

protocol EditProfileViewControllerDelegate: AnyObject {
  func editProfileViewController(
    _ viewController: EditProfileViewController,
    didFinishEditing user: NLetterPoemUser?
  )
}

final class EditProfileViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var editProfileView: EditProfileView!
  
  //MARK: - Properties
  var updatedUser: NLetterPoemUser?
  weak var delegate: EditProfileViewControllerDelegate?
  
  //MARK: - Initializer
  init(_ user: NLetterPoemUser) {
    super.init(nibName: nil, bundle: nil)
//    editProfileView = EditProfileView(user: user)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    layout()
  }
}

//MARK: - Layout
extension EditProfileViewController {
  private func configure() {
    editProfileView.delegate = self
  }
  
  private func layout() {
    view.addSubview(editProfileView)

    NSLayoutConstraint.activate([
      editProfileView.topAnchor.constraint(equalTo: view.topAnchor),
      editProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      editProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      editProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

//MARK: - EditProfileViewDelegate
extension EditProfileViewController: EditProfileViewDelegate {
  func editProfileView(
    _ editProfileView: EditProfileView,
    doneEdit info: [String : String?]
  ) {
    
  }
  
  func editProfileView(
    _ editProfileView: EditProfileView,
    cancelEdit button: UIBarButtonItem
  ) {
    dismiss(animated: true, completion: nil)
  }
  
  private func updateUserData() {
  }
}
