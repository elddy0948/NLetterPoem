import UIKit

class SignInViewController: UIViewController {
    
    //MARK: - Views
    private var signinStackView: UIStackView!
    private(set) var emailTextField: NLPTextField!
    private(set) var passwordTextField: NLPTextField!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInStackView()
        configure()
        configureLayout()
    }
    
    private func configure() {
        view.addSubview(signinStackView)
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인"
    }
    
    private func configureSignInStackView() {
        emailTextField = NLPTextField(type: .email)
        passwordTextField = NLPTextField(type: .password)
        
        signinStackView = UIStackView()
        signinStackView.distribution = .equalSpacing
        signinStackView.axis = .vertical
        signinStackView.translatesAutoresizingMaskIntoConstraints = false
        signinStackView.spacing = 8
        
        signinStackView.addArrangedSubview(emailTextField)
        signinStackView.addArrangedSubview(passwordTextField)
    }
    
    private func configureLayout() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            signinStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signinStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signinStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
