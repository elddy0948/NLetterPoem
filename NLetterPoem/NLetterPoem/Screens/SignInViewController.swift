import UIKit

class SignInViewController: UIViewController {
    
    //MARK: - Views
    private var signinStackView: UIStackView!
    private(set) var emailTextField: NLPTextField!
    private(set) var passwordTextField: NLPTextField!
    private let logoImageView = NLPLogoImageView(frame: .zero)
    private(set) var signinButton: NLPButton!
    private(set) var signupButton: NLPButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInStackView()
        configure()
        configureLayout()
    }
    
    private func configure() {
        view.addSubview(signinStackView)
        view.addSubview(logoImageView)
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인"
    }
    
    private func configureSignInStackView() {
        emailTextField = NLPTextField(type: .email)
        passwordTextField = NLPTextField(type: .password)
        signinButton = NLPButton(title: "로그인")
        signupButton = NLPButton(title: "회원가입")
        
        signinStackView = UIStackView()
        signinStackView.distribution = .equalSpacing
        signinStackView.axis = .vertical
        signinStackView.translatesAutoresizingMaskIntoConstraints = false
        signinStackView.spacing = 8
        
        signinStackView.addArrangedSubview(emailTextField)
        signinStackView.addArrangedSubview(passwordTextField)
        signinStackView.addArrangedSubview(signinButton)
        signinStackView.addArrangedSubview(signupButton)
    }
    
    private func configureLayout() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signinStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signinStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signinStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),
            signinButton.heightAnchor.constraint(equalToConstant: 52),
            signupButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}
