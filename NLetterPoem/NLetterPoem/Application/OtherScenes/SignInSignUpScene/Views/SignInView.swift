import UIKit

//MARK: - SigninViewDelegate
protocol SigninViewDelegate: AnyObject {
  func signinView(_ signinView: SignInView, didTapSignin button: NLPButton, email: String?, password: String?)
  func signinView(_ signinView: SignInView, didTapSignup button: NLPButton)
}

final class SignInView: UIView {
  
  //MARK: - Views
  private(set) var logoImageView: NLPLogoImageView!
  private var signinStackView: UIStackView!
  private(set) var emailTextField: NLPTextField!
  private(set) var passwordTextField: NLPTextField!
  private(set) var signinButton: NLPButton!
  private(set) var signupButton: NLPButton!
  private var views = [UIView]()
  
  //MARK: - Properties
  weak var delegate: SigninViewDelegate?
  
  //MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    configureLogoImageView()
    configureSignInStackView()
    configureViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Privates
  private func configureLogoImageView() {
    logoImageView = NLPLogoImageView(frame: .zero)
    addSubview(logoImageView)
    
    NSLayoutConstraint.activate([
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -160),
      logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 160),
      logoImageView.heightAnchor.constraint(equalToConstant: 160),
    ])
  }
  
  private func configureSignInStackView() {
    let padding: CGFloat = 16
    signinStackView = UIStackView()
    addSubview(signinStackView)
    
    signinStackView.translatesAutoresizingMaskIntoConstraints = false
    signinStackView.axis = .vertical
    signinStackView.distribution = .fill
    signinStackView.spacing = 8
    
    NSLayoutConstraint.activate([
      signinStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: padding),
      signinStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      signinStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
    ])
  }
  
  private func configureViews() {
    let textFieldHeight: CGFloat = 48
    
    emailTextField = NLPTextField(type: .email)
    passwordTextField = NLPTextField(type: .password)
    signinButton = NLPButton(title: "로그인")
    signupButton = NLPButton(title: "회원가입")
    
    emailTextField.returnKeyType = .next
    passwordTextField.placeholder = "Password"
    
    passwordTextField.delegate = self
    emailTextField.delegate = self
    signinButton.addTarget(self, action: #selector(signinButtonAction(_:)), for: .touchUpInside)
    signupButton.addTarget(self, action: #selector(signupButtonAction(_:)), for: .touchUpInside)
    
    views = [emailTextField, passwordTextField, signinButton, signupButton]
    
    for view in views {
      signinStackView.addArrangedSubview(view)
      view.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
  }
  
  @objc func signinButtonAction(_ sender: NLPButton) {
    let email = emailTextField.text
    let password = passwordTextField.text
    
    delegate?.signinView(self, didTapSignin: sender, email: email, password: password)
  }
  
  @objc func signupButtonAction(_ sender: NLPButton) {
    delegate?.signinView(self, didTapSignup: sender)
  }
}

extension SignInView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      emailTextField.resignFirstResponder()
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      delegate?.signinView(self,
                           didTapSignin: signinButton,
                           email: emailTextField.text,
                           password: passwordTextField.text)
    }
    return true
  }
}
