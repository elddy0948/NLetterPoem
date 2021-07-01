import UIKit

class EditProfileViewController: UIViewController {
    
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
    
    @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
        
    }
}

extension EditProfileViewController: EditProfileViewDelegate {
    func didTappedCancelButton(_ editProfileView: EditProfileView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTappedDoneButton(_ editProfileView: EditProfileView, with user: NLPUser) {
        DatabaseManager.shared.updateUser(with: user) { error in
            if let error = error {
                debugPrint(error)
                self.showAlert(title: "⚠️", message: "정보 변경에 실패했습니다!!")
                self.dismiss(animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
