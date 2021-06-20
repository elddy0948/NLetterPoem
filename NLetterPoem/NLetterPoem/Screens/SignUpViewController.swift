import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - Views
    private var signupStackView: UIStackView!
    private let logoImageView = NLPLogoImageView(frame: .zero)
    private(set) var emailTextField = NLPTextField(type: .email)
    private(set) var passwordTextField = NLPTextField(type: .password)
    private(set) var nicknameTextField = NLPTextField(type: .nickname)
    private(set) var signupButton = NLPButton(title: "가입하기")
    private var views: [UIView]!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignupStackView()
        configure()
        configureLayout()
    }
    
    //MARK: - Privates
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(signupStackView)
        signupButton.delegate = self
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
    
    private func createUser() -> User? {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let nickname = nicknameTextField.text else {
            return nil
        }
        return User(email: email, password: password, profilePhotoURL: "", nickname: nickname, bio: "")
    }
}

extension SignUpViewController: NLPButtonDelegate {
    func didTappedButton(_ sender: NLPButton) {
        guard let user = createUser() else { return }
        DatabaseManager.shared.checkUserExist(with: user) { [weak self] isUserExist in
            guard let self = self else { return }
            if isUserExist {
                print("user exist!")
                return
            } else {
                self.insertUserInDatabase(with: user)
            }
        }
    }
    private func insertUserInDatabase(with user: User) {
        DatabaseManager.shared.createUser(with: user) { user in
            print(user)
        }
    }
}
