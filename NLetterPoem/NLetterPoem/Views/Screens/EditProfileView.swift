import UIKit

protocol EditProfileViewDelegate: AnyObject {
  func editProfileView(_ editProfileView: EditProfileView, cancelEdit button: UIBarButtonItem)
  func editProfileView(_ editProfileView: EditProfileView, doneEdit user: NLPUser)
}

class EditProfileView: UIView {
  
  //MARK: - Views
  private(set) var navigationBar: UINavigationBar!
  private(set) var nicknameTextField: NLPTextField!
  private(set) var bioTextView: UITextView!
  
  //MARK: - Properties
  private var user: NLPUser!
  weak var delegate: EditProfileViewDelegate?
  
  //MARK: - init
  init(user: NLPUser) {
    super.init(frame: .zero)
    self.user = user
    configure()
    configureNavigationBar()
    configureNicknameTextField()
    configureBioTextView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Privates
  private func configure() {
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureNavigationBar() {
    navigationBar = UINavigationBar()
    addSubview(navigationBar)
    
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    navigationBar.barTintColor = .systemBackground
    navigationBar.tintColor = .label
    
    configureNavigationItem()
    
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  private func configureNavigationItem() {
    let item = UINavigationItem(title: "프로필 수정")
    let cancelButton = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(didTappedCancelButton(_:)))
    let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTappedDoneButton(_:)))
    
    item.leftBarButtonItem = cancelButton
    item.rightBarButtonItem = doneButton
    
    navigationBar.pushItem(item, animated: true)
  }
  
  private func configureNicknameTextField() {
    nicknameTextField = NLPTextField(type: .nickname)
    addSubview(nicknameTextField)
    nicknameTextField.text = user.nickname
    
    NSLayoutConstraint.activate([
      nicknameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      nicknameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      nicknameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      nicknameTextField.heightAnchor.constraint(equalToConstant: 52),
    ])
  }
  
  private func configureBioTextView() {
    bioTextView = UITextView()
    addSubview(bioTextView)
    
    bioTextView.translatesAutoresizingMaskIntoConstraints = false
    bioTextView.text = user.bio
    bioTextView.autocorrectionType = .no
    bioTextView.autocapitalizationType = .none
    bioTextView.backgroundColor = .secondarySystemBackground
    bioTextView.layer.borderColor = UIColor.systemGray.cgColor
    bioTextView.layer.borderWidth = 3
    bioTextView.layer.cornerRadius = 16
    bioTextView.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      bioTextView.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 16),
      bioTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      bioTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      bioTextView.heightAnchor.constraint(equalToConstant: 150),
    ])
  }
  
  //MARK: - Actions
  @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
    delegate?.editProfileView(self, cancelEdit: sender)
  }
  
  @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
    guard let nickname = nicknameTextField.text,
          let bio = bioTextView.text,
          let user = user else {
      delegate?.editProfileView(self, cancelEdit: sender)
      return
    }
    user.nickname = nickname
    user.bio = bio
    
    delegate?.editProfileView(self, doneEdit: user)
  }
}
