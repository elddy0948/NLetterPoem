import UIKit

protocol SignUpViewDelegate: AnyObject {
  func signupView(_ signupView: SignUpView, didTapRegister info: SignupInfo?, error: String?)
}

struct SignupInfo {
  let email: String
  let password: String
  let nickname: String
}

final class SignUpView: UIView {
  
  //MARK: - Views
  private(set) var logoImageView: NLPLogoImageView!
  private var signupStackView: UIStackView!
  private(set) var emailTextField = NLPTextField(type: .email)
  private(set) var passwordTextField = NLPTextField(type: .password)
  private(set) var repeatPasswordTextField = NLPTextField(type: .repeatPassword)
  private(set) var nicknameTextField = NLPTextField(type: .nickname)
  private(set) var signupButton = NLPButton(title: "가입하기")
  private var views: [UIView]!
  private var textFields: [NLPTextField]!
  
  //MARK: - Properties
  weak var delegate: SignUpViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    configureLogoImageView()
    configureStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureLogoImageView() {
    let imageWidth: CGFloat = 160
    
    logoImageView = NLPLogoImageView(frame: .zero)
    addSubview(logoImageView)
    
    NSLayoutConstraint.activate([
      logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(imageWidth + 20)),
      logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: imageWidth),
      logoImageView.heightAnchor.constraint(equalToConstant: imageWidth),
    ])
  }
  
  private func configureStackView() {
    let padding: CGFloat = 16
    
    textFields = [emailTextField, passwordTextField, repeatPasswordTextField, nicknameTextField]
    views = [signupButton]
    signupStackView = UIStackView()
    addSubview(signupStackView)
    
    signupStackView.axis = .vertical
    signupStackView.distribution = .equalSpacing
    signupStackView.translatesAutoresizingMaskIntoConstraints = false
    signupStackView.spacing = 4
    
    // TextField
    for textField in textFields {
      textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
      textField.delegate = self
      textField == nicknameTextField ? (textField.returnKeyType = .done) : (textField.returnKeyType = .next)
      signupStackView.addArrangedSubview(textField)
    }
    
    // Signup Button
    signupButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    signupStackView.addArrangedSubview(signupButton)
    signupButton.addTarget(self, action: #selector(signupButtonAction(_:)), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      signupStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: padding),
      signupStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      signupStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
    ])
  }
  
  @objc func signupButtonAction(_ sender: NLPButton) {
    guard passwordTextField.text == repeatPasswordTextField.text else {
      delegate?.signupView(self, didTapRegister: nil, error: "패스워드가 일치하지 않습니다!")
      return
    }
    
    guard let email = emailTextField.text,
          let password = passwordTextField.text,
          let nickname = nicknameTextField.text,
          !email.isEmpty, !password.isEmpty,
          !nickname.isEmpty else {
      delegate?.signupView(self, didTapRegister: nil,
                           error: "빈칸을 채워주세요!")
      return
    }
    
    guard email.isValidEmail() else {
      delegate?.signupView(self, didTapRegister: nil,
                           error: "이메일 형식을 확인해주세요!")
      return
    }
    
    guard password.isValidPassword() else {
      delegate?.signupView(self, didTapRegister: nil,
                           error: "비밀번호는 최소 8자리 이상, 영어와 숫자를 포함해주세요!")
      return
    }
    
    let signupInfo = SignupInfo(email: email, password: password, nickname: nickname)
    delegate?.signupView(self, didTapRegister: signupInfo, error: nil)
  }
}

extension SignUpView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField:
      emailTextField.resignFirstResponder()
      passwordTextField.becomeFirstResponder()
    case passwordTextField:
      passwordTextField.resignFirstResponder()
      repeatPasswordTextField.becomeFirstResponder()
    case repeatPasswordTextField:
      repeatPasswordTextField.resignFirstResponder()
      nicknameTextField.becomeFirstResponder()
    case nicknameTextField:
      nicknameTextField.resignFirstResponder()
      signupButtonAction(signupButton)
    default:
      textField.resignFirstResponder()
    }
    return true
  }
}
