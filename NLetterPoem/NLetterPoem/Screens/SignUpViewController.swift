import UIKit

class SignUpViewController: UIViewController {
    
    private var signupStackView: UIStackView!
    private let logoImageView = NLPLogoImageView(frame: .zero)
    private(set) var emailTextField = NLPTextField(type: .email)
    private(set) var passwordTextField = NLPTextField(type: .password)
    private(set) var nicknameTextField = NLPTextField(type: .normal)
    private(set) var signupButton = NLPButton(title: "가입하기")
    private var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignupStackView()
        configure()
        configureLayout()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(signupStackView)
    }
    
    private func configureSignupStackView() {
        views = [emailTextField, passwordTextField, nicknameTextField, signupButton]
        signupStackView = UIStackView()
        signupStackView.axis = .vertical
        signupStackView.distribution = .equalSpacing
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        signupStackView.spacing = 8
        
        for view in views { signupStackView.addArrangedSubview(view) }
    }
    
    private func configureLayout() {
        let padding: CGFloat = 8
        for view in views { view.heightAnchor.constraint(equalToConstant: 52).isActive = true }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            signupStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signupStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
