import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
  
  //MARK: - Views
  private(set) var navigationBar: NLPNavigationBar!
  private(set) var signUpView: SignUpView!
  private(set) var tapGestureRecognizer: UITapGestureRecognizer!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureGestureRecognizer()
    configureNavigationBar()
    configureSignUpView()
  }
  
  //MARK: - Privates
  private func configure() {
    view.backgroundColor = .systemBackground
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillAppear(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillDisappear(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  private func configureGestureRecognizer() {
    tapGestureRecognizer = UITapGestureRecognizer(target: view,
                                                  action: #selector(UIView.endEditing(_:)))
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func configureNavigationBar() {
    navigationBar = NLPNavigationBar(title: "회원가입",
                                     leftTitle: "닫기",
                                     rightTitle: nil)
    view.addSubview(navigationBar)
    
    navigationBar.nlpDelegate = self
    
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  private func configureSignUpView() {
    signUpView = SignUpView()
    view.addSubview(signUpView)
    
    signUpView.delegate = self
    
    NSLayoutConstraint.activate([
      signUpView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      signUpView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  //MARK: - Actions
  @objc private func keyboardWillAppear(notification: Notification) {
    if view.frame.origin.y == 0 {
      view.frame.origin.y -= 85
    }
  }
  
  @objc private func keyboardWillDisappear(notification: Notification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y += 85
    }
  }
}

extension SignUpViewController: SignUpViewDelegate {
  func signupView(_ signupView: SignUpView,
                  didTapRegister info: SignupInfo?,
                  error: String?) {
    if let error = error {
      self.showAlert(title: "⚠️", message: error, action: nil)
      return
    }
    
    guard let info = info else {
      self.showAlert(title: "⚠️",
                     message: "다시 시도해주세요!",
                     action: nil)
      return
    }
    createUser(with: info)
  }
  
  private func createUser(with info: SignupInfo) {
    AuthManager.shared.createUser(with: info) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let message):
        self.storeUserInDatabase(with: info)
        debugPrint(message)
      case .failure(_):
        self.showAlert(title: "⚠️",
                       message: "회원가입이 실패했어요!\n다시 시도해주세요!",
                       action: nil)
        return
      }
    }
  }
  
  private func storeUserInDatabase(with info: SignupInfo) {
    let user = NLPUser(email: info.email,
                       profilePhotoURL: "",
                       nickname: info.nickname,
                       bio: "")
    
    UserDatabaseManager.shared.create(user) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        self.showAlert(title: "🎉",
                       message: "회원가입을 축하합니다!") { _ in
          self.dismiss(animated: true, completion: nil)
        }
      case .failure(_):
        self.showAlert(title: "⚠️",
                       message: "회원 저장에 실패했어요!\n다시 시도해주세요!",
                       action: nil)
      }
    }
  }
}

extension SignUpViewController: NLPNavigationBarDelegate {
  func nlpNavigationBar(_ nlpNavigationBar: NLPNavigationBar,
                        didTapLeftBarButton leftBarButton: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}
