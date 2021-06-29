import UIKit

class MyPageHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: MyPageHeaderView.self)
    
    //MARK: - Views
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var bioLabel: NLPProfileLabel!
    private(set) var editProfileButton: NLPButton!
    private(set) var horizontalStackView: UIStackView!
    
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
        bioLabel.text = user.bio
    }
    
    //MARK: - Privates
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
        configureEditProfileButton()
    }
    
    private func configureStackView() {
        horizontalStackView = UIStackView()
        addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 16
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        configureLayoutUI()
        
        profilePhotoImageView = NLPProfilePhotoImageView(size: 100)
        bioLabel = NLPProfileLabel(type: .bio)
        
        horizontalStackView.addArrangedSubview(profilePhotoImageView)
        horizontalStackView.addArrangedSubview(bioLabel)
    }
    
    private func configureEditProfileButton() {
        let padding: CGFloat = 8
        editProfileButton = NLPButton(title: "프로필 수정")
        addSubview(editProfileButton)
        
        NSLayoutConstraint.activate([
            editProfileButton.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: padding),
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            editProfileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            editProfileButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func configureLayoutUI() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}
