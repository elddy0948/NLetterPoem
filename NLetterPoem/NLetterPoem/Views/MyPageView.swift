import UIKit

class MyPageView: UIView {
    
    //MARK: - Views
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var nicknameLabel: NLPProfileLabel!
    private(set) var bioLabel: NLPProfileLabel!
    
    //MARK: - Properties
    private var user: NLPUser!
    
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureProfilePhotoImageView()
        configureNicknameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        backgroundColor = .systemGreen
        translatesAutoresizingMaskIntoConstraints = false
        guard let user = NLPUser.shared else { return }
        self.user = user
    }
    
    private func configureProfilePhotoImageView() {
        let padding: CGFloat = 16
        profilePhotoImageView = NLPProfilePhotoImageView(size: 150)
        addSubview(profilePhotoImageView)
        
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])
    }
    
    private func configureNicknameLabel() {
        let padding: CGFloat = 16
        nicknameLabel = NLPProfileLabel(type: .nickname, text: user.nickname)
        addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            nicknameLabel.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: padding),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
