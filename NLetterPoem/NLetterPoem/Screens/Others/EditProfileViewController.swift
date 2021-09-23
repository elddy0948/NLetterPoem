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
  
  private func uploadImage(data: Data, email: String) {
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else { return }
      StorageManager.shared.uploadImage(with: data, email: email) { url in
        if let url = url {
          self.updatedUser?.profilePhotoURL = url.absoluteString
          self.updateUserData(self.updatedUser)
        } else {
          self.updatedUser?.profilePhotoURL = ""
        }
      }
    }
  }
}

extension EditProfileViewController: EditProfileViewDelegate {
  func editProfileView(_ editProfileView: EditProfileView, cancelEdit button: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func editProfileView(_ editProfileView: EditProfileView, doneEdit user: NLPUser, imageData: Data) {
    showLoadingView()
    updatedUser = user
    uploadImage(data: imageData, email: user.email)
  }
  
  func editProfileView(_ editProfileView: EditProfileView, didTapImageView: NLPProfilePhotoImageView) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.allowsEditing = true
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true, completion: nil)
  }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var selectedImage: UIImage
    
    if let possibleImage = info[.editedImage] as? UIImage {
      selectedImage = possibleImage
    } else if let possibleImage = info[.originalImage] as? UIImage {
      selectedImage = possibleImage
    } else { return }
    
    editProfileView.setProfileImage(with: selectedImage)
    dismiss(animated: true, completion: nil)
  }
}
