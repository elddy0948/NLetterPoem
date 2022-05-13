import UIKit

protocol EditProfileViewDelegate: AnyObject {
  func editProfileView(
    _ editProfileView: EditProfileView,
    cancelEdit button: UIBarButtonItem
  )
  func editProfileView(
    _ editProfileView: EditProfileView,
    doneEdit info: [String: String?]
  )
}

final class EditProfileView: UIView {
  
  //MARK: - Views
  private lazy var navigationBar: UINavigationBar = {
    let navBar = UINavigationBar()
    navBar.barTintColor = .systemBackground
    navBar.tintColor = .label
    return navBar
  }()
  private lazy var nicknameTextField = NLPTextField(type: .nickname)
  private lazy var bioTextView: UITextView = {
    let textView = UITextView()
    textView.autocorrectionType = .no
    textView.autocapitalizationType = .none
    textView.backgroundColor = .secondarySystemBackground
    textView.layer.borderColor = UIColor.systemGray.cgColor
    textView.layer.borderWidth = 3
    textView.layer.cornerRadius = 16
    textView.layer.masksToBounds = true
    return textView
  }()
  
  //MARK: - Properties
  weak var delegate: EditProfileViewDelegate?
  
  //MARK: - init
  init(user: NLetterPoemUser) {
    super.init(frame: .zero)
    configure()
    configureNavigationItem()
    configureSubViewData(with: user)
    layout()
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
  
  private func configureNavigationItem() {
    let item = UINavigationItem(title: "프로필 수정")
    let cancelButton = UIBarButtonItem(
      title: "닫기",
      style: .plain,
      target: self,
      action: #selector(didTappedCancelButton(_:))
    )
    let doneButton = UIBarButtonItem(
      title: "완료",
      style: .done,
      target: self,
      action: #selector(didTappedDoneButton(_:))
    )
    
    item.leftBarButtonItem = cancelButton
    item.rightBarButtonItem = doneButton
    
    navigationBar.pushItem(item, animated: true)
  }
  
  private func configureSubViewData(with user: NLetterPoemUser) {
    nicknameTextField.text = user.nickname
    bioTextView.text = user.bio
  }
  
  //MARK: - Actions
  @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
    delegate?.editProfileView(self, cancelEdit: sender)
  }
  
  @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
    let info = [
      "nickname" : nicknameTextField.text,
      "bio" : bioTextView.text
    ]
    delegate?.editProfileView(self, doneEdit: info)
  }
}

//MARK: - Layout / UI Setup
extension EditProfileView {
  private func layout() {
    self.addSubview(navigationBar)
    self.addSubview(nicknameTextField)
    self.addSubview(bioTextView)
    
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
    bioTextView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(
        equalTo: safeAreaLayoutGuide.topAnchor
      ),
      navigationBar.leadingAnchor.constraint(
        equalTo: leadingAnchor
      ),
      navigationBar.trailingAnchor.constraint(
        equalTo: trailingAnchor
      ),
      nicknameTextField.topAnchor.constraint(
        equalTo: navigationBar.bottomAnchor, constant: 16
      ),
      nicknameTextField.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: 16
      ),
      nicknameTextField.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -16
      ),
      nicknameTextField.heightAnchor.constraint(
        equalToConstant: 52
      ),
      bioTextView.topAnchor.constraint(
        equalTo: nicknameTextField.bottomAnchor,
        constant: 16
      ),
      bioTextView.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: 16
      ),
      bioTextView.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -16
      ),
      bioTextView.heightAnchor.constraint(equalToConstant: 150),
    ])
  }
}
