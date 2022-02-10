import UIKit
import FirebaseAuth

protocol SignInViewControllerDelegate: AnyObject {
  func registerAction(
    _ viewController: UIViewController
  )
  
  func signInAction(
    _ viewController: UIViewController
  )
}

class SignInViewController: UIViewController {
  
  //MARK: - Views
  private lazy var signinView = SignInView()
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self.view,
      action: #selector(UIView.endEditing(_:))
    )
    return tapGestureRecognizer
  }()
  
  //MARK: - Properties
  weak var delegate: SignInViewControllerDelegate?
  private var isUserSignin = false
  
  //MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
    setupSubviews()
    layout()
  }
  
  //MARK: - Actions
  @objc private func keyboardWillShown(notification: Notification) {
    if view.frame.origin.y == 0 {
      view.frame.origin.y -= 50
    }
  }
  
  @objc private func keyboardWillDisappear(notification: Notification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y += 50
    }
  }
}

//MARK: - Setup ViewController
extension SignInViewController {
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    view.addGestureRecognizer(tapGestureRecognizer)
    setupNotification()
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShown(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillDisappear(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
}

//MARK: - SigninViewDelegate
extension SignInViewController: SigninViewDelegate {
  func signinView(_ signinView: SignInView,
                  didTapSignin button: NLPButton,
                  email: String?,
                  password: String?) {
    guard let email = email,
          let password = password else {
            self.showAlert(
              title: "⚠️",
              message: "이메일과 패스워드를 다시 확인해주세요!",
              action: nil
            )
            return
          }
    
    signin(email: email, password: password)
  }
  
  func signinView(
    _ signinView: SignInView,
    didTapSignup button: NLPButton
  ) {
    delegate?.registerAction(self)
  }
  
  private func signin(email: String, password: String) {
    AuthManager.shared.signin(
      email: email,
      password: password
    ) { [weak self] error in
      guard let self = self else { return }
      defer {
        if self.isUserSignin {
          self.delegate?.signInAction(self)
        }
      }
      if let error = error {
        debugPrint(error)
        self.showAlert(
          title: "⚠️",
          message: "로그인에 실패했어요!\n다시 시도해주세요!",
          action: nil
        )
        self.isUserSignin = false
        return
      }
      self.isUserSignin = true
    }
  }
}

//MARK: - UI Setup / Layout
extension SignInViewController {
  private func setupSubviews() {
    view.addSubview(signinView)
    signinView.delegate = self
  }
  
  private func layout() {
    let padding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      signinView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor
      ),
      signinView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor, constant: padding
      ),
      signinView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor, constant: -padding
      ),
      signinView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      ),
    ])
  }
}
