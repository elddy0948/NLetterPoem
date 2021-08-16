import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
  
  //MARK: - Views
  private(set) var signinView: SignInView!
  private(set) var tapGestureRecognizer: UITapGestureRecognizer!
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureSigninView()
    configureTapGestureRecognizer()
  }
  
  private func configure() {
    view.backgroundColor = .systemBackground
    navigationController?.isNavigationBarHidden = true
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShown(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillDisappear(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  private func configureSigninView() {
    let padding: CGFloat = 8
    signinView = SignInView()
    view.addSubview(signinView)
    
    signinView.delegate = self
    
    NSLayoutConstraint.activate([
      signinView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      signinView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      signinView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      signinView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func configureTapGestureRecognizer() {
    tapGestureRecognizer = UITapGestureRecognizer(target: view,
                                                  action: #selector(UIView.endEditing(_:)))
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func showSignupViewController() {
    let viewController = SignUpViewController()
    self.present(viewController, animated: true, completion: nil)
  }
  
  @objc private func keyboardWillShown(notification: Notification) {
    if view.frame.origin.y == 0 {
      view.frame.origin.y -= 70
    }
  }
  
  @objc private func keyboardWillDisappear(notification: Notification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y += 70
    }
  }
}


extension SignInViewController: SigninViewDelegate {
  func signinView(_ signinView: SignInView, didTapSignin button: NLPButton, email: String?, password: String?) {
    guard let email = email,
          let password = password else {
      self.showAlert(title: "⚠️", message: "이메일과 패스워드를 다시 확인해주세요!", action: nil)
      return
    }
    
    AuthManager.shared.signin(email: email, password: password) { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        debugPrint(error)
        self.showAlert(title: "⚠️", message: "로그인에 실패했어요!\n다시 시도해주세요!", action: nil)
        return
      }
      self.navigationController?.popToRootViewController(animated: false)
    }
  }
  
  func signinView(_ signinView: SignInView, didTapSignup button: NLPButton) {
    showSignupViewController()
  }
}
