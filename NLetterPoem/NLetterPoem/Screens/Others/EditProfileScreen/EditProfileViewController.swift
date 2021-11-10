import UIKit
import Firebase

protocol EditProfileViewControllerDelegate: AnyObject {
  func editProfileViewController(_ viewController: EditProfileViewController, didFinishEditing user: NLPUser?)
}

class EditProfileViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var editProfileView: EditProfileView!
  
  //MARK: - Properties
  var updatedUser: NLPUser?
  weak var delegate: EditProfileViewControllerDelegate?
  
  //MARK: - Initializer
  init(_ user: NLPUser) {
    super.init(nibName: nil, bundle: nil)
    editProfileView = EditProfileView(user: user)
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
  func editProfileView(_ editProfileView: EditProfileView, cancelEdit button: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func editProfileView(_ editProfileView: EditProfileView, doneEdit user: NLPUser) {
    showLoadingView()
    updatedUser = user
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self,
            let updatedUser = self.updatedUser else { return }
      self.updateUserData(updatedUser)
    }
  }
  
  private func updateUserData(_ user: NLPUser?) {
    guard let user = user else { return }
    UserDatabaseManager.shared.update(user) { [weak self] result in
      guard let self = self else { return }
      self.dismissLoadingView()
      switch result {
      case .success(_):
        self.showAlert(title: "🎉", message: "정보 변경을 완료했습니다!") { _ in
          self.dismiss(animated: true, completion: {
            self.delegate?.editProfileViewController(self, didFinishEditing: self.updatedUser)
          })
        }
      case .failure(_):
        self.showAlert(title: "⚠️", message: "정보 변경에 실패했습니다!!") { _ in
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
}
