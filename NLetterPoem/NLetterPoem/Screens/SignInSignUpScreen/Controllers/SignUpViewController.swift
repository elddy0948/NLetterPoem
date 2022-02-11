import UIKit
import FirebaseAuth

class SignUpViewController: DataLoadingViewController {
  
  //MARK: - Views
  private lazy var navigationBar = NLPNavigationBar(
    title: "회원가입",
    leftTitle: "닫기",
    rightTitle: nil
  )
  private lazy var signUpView = SignUpView()
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gestureRecognizer = UITapGestureRecognizer(
      target: self.view,
      action: #selector(UIView.endEditing(_:))
    )
    return gestureRecognizer
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
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

//MARK: - SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
  func signupView(_ signupView: SignUpView,
                  didTapRegister info: SignupInfo?,
                  error: String?) {
    if let error = error {
      self.showAlert(title: "⚠️", message: error, action: nil)
      return
    }
    
    guard let info = info else {
      self.showAlert(
        title: "⚠️", message: "다시 시도해주세요!", action: nil
      )
      return
    }
    
    createUser(with: info)
  }
  
  private func createUser(with info: SignupInfo) {
    showLoadingView()
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      AuthManager.shared.createUser(with: info) { result in
        switch result {
        case .success(let message):
          self.storeUserInDatabase(with: info)
          debugPrint(message)
        case .failure(_):
          self.showAlert(
            title: "⚠️", message: "회원가입이 실패했어요!\n다시 시도해주세요!",
            action: nil
          )
          return
        }
      }
    }
  }
  
  private func storeUserInDatabase(with info: SignupInfo) {
    let user = NLPUser(
      email: info.email, nickname: info.nickname, bio: "")
    
    UserDatabaseManager.shared.create(user) { [weak self] result in
      guard let self = self else { return }
      self.dismissLoadingView()
      switch result {
      case .success(_):
        self.showAlert(
          title: "🎉", message: "회원가입을 축하합니다!"
        ) { _ in
          self.dismiss(animated: true, completion: nil)
        }
      case .failure(_):
        self.showAlert(
          title: "⚠️",
          message: "회원 저장에 실패했어요!\n다시 시도해주세요!", action: nil
        )
      }
    }
  }
}

//MARK: - NLPNavigationBarDelegate
extension SignUpViewController: NLPNavigationBarDelegate {
  func nlpNavigationBar(
    _ nlpNavigationBar: NLPNavigationBar,
    didTapLeftBarButton leftBarButton: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: - UI Setup / Layout
extension SignUpViewController {
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    setupNotification()
    
    view.addGestureRecognizer(tapGestureRecognizer)
    
    setupNavigationBar()
    setupSignUpView()
    layout()
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillAppear(notification:)),
      name: UIResponder.keyboardWillShowNotification, object: nil
    )
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillDisappear(notification:)),
      name: UIResponder.keyboardWillHideNotification, object: nil
    )
  }
  
  private func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.nlpDelegate = self
  }
  
  private func setupSignUpView() {
    view.addSubview(signUpView)
    signUpView.delegate = self
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      signUpView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      signUpView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
