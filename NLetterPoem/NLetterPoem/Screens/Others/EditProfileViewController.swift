import UIKit
import Firebase

class EditProfileViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var editProfileView: EditProfileView!
  
  //MARK: - Properties
  var user: NLPUser?
  var updatedUser: NLPUser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  private func configure() {
    guard let user = user else { return }
    editProfileView = EditProfileView(user: user)
    view.addSubview(editProfileView)
    
    editProfileView.delegate = self
    
    NSLayoutConstraint.activate([
      editProfileView.topAnchor.constraint(equalTo: view.topAnchor),
      editProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      editProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      editProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
  private func updateUserData(_ user: NLPUser?) {
    guard let user = user else { return }
    UserDatabaseManager.shared.update(user) { result in
      self.dismissLoadingView()
      switch result {
      case .success(_):
        self.showAlert(title: "🎉", message: "정보 변경을 완료했습니다!") { _ in
          self.dismiss(animated: true, completion: nil)
        }
      case .failure(_):
        self.showAlert(title: "⚠️", message: "정보 변경에 실패했습니다!!") { _ in
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
}

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
}
