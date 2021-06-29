import UIKit

class MyPageHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: MyPageHeaderView.self)
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Mypage Data
    func configureUser(with user: NLPUser) {
        nicknameLabel.text = user.nickname
        bioLabel.text = user.bio
    }
    
    //MARK: - Privates
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configureProfilePhotoImageView()
        configureNicknameLabel()
        configureBioLabel()
    }
    
    private func configureProfilePhotoImageView() {
        let padding: CGFloat = 16
        profilePhotoImageView = NLPProfilePhotoImageView(size: 100)
        addSubview(profilePhotoImageView)
        
        NSLayoutConstraint.activate([
            profilePhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])
    }
    
    private func configureNicknameLabel() {
        let padding: CGFloat = 16
        nicknameLabel = NLPProfileLabel(type: .nickname)
        addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            nicknameLabel.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: padding),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureBioLabel() {
        let padding: CGFloat = 16
        bioLabel = NLPProfileLabel(type: .bio)
        addSubview(bioLabel)
        
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor, constant: padding),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            bioLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}
