import UIKit

class EditProfileViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var editProfileView: EditProfileView!
  
  //MARK: - Properties
  var user: NLPUser?
  
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
}

extension EditProfileViewController: EditProfileViewDelegate {
  func didTappedCancelButton(_ editProfileView: EditProfileView) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func didTappedDoneButton(_ editProfileView: EditProfileView, with user: NLPUser) {
    showLoadingView()
    DispatchQueue.global(qos: .utility).async {
      UserDatabaseManager.shared.update(user) { [weak self] result in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.dismissLoadingView()
        }
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
  
  func didTappedImageView(_ editProfileView: EditProfileView) {
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
