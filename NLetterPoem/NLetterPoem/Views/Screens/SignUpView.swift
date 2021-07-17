import UIKit

protocol SignUpViewDelegate: AnyObject {
    func signupView(_ signupView: SignUpView, didTapRegister info: SignupInfo?, error: String?)
}

struct SignupInfo {
    let email: String
    let password: String
    let nickname: String
}

class SignUpView: UIView {
    
    //MARK: - Views
    private(set) var logoImageView: NLPLogoImageView!
    private var signupStackView: UIStackView!
    private(set) var emailTextField = NLPTextField(type: .email)
    private(set) var passwordTextField = NLPTextField(type: .password)
    private(set) var repeatPasswordTextField = NLPTextField(type: .repeatPassword)
    private(set) var nicknameTextField = NLPTextField(type: .nickname)
    private(set) var signupButton = NLPButton(title: "가입하기")
    private var views: [UIView]!
    
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
        let padding: CGFloat = 16
        let imageWidth: CGFloat = 100
        
        logoImageView = NLPLogoImageView(frame: .zero)
        addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: imageWidth),
        ])
    }
    
    private func configureStackView() {
        let padding: CGFloat = 8
        
        views = [emailTextField, passwordTextField, repeatPasswordTextField, nicknameTextField, signupButton]
        signupStackView = UIStackView()
        addSubview(signupStackView)
        
        signupStackView.axis = .vertical
        signupStackView.distribution = .equalSpacing
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        signupStackView.spacing = 8
        
        for view in views {
            view.heightAnchor.constraint(equalToConstant: 52).isActive = true
            signupStackView.addArrangedSubview(view)
        }
        
        signupButton.addTarget(self, action: #selector(signupButtonAction(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signupStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            signupStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            signupStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
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
            delegate?.signupView(self, didTapRegister: nil, error: "빈칸을 채워주세요!")
            return
        }
        
        let signupInfo = SignupInfo(email: email, password: password, nickname: nickname)
        delegate?.signupView(self, didTapRegister: signupInfo, error: nil)
    }
}
