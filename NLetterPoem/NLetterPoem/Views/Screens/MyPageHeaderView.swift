import UIKit

protocol MyPageHeaderViewDelegate: AnyObject {
    func didTappedEditProfileButton(_ sender: NLPButton)
}

final class MyPageHeaderView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: MyPageHeaderView.self)
    
    //MARK: - Views
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var bioLabel: NLPProfileLabel!
    private(set) var editProfileButton: NLPButton!
    private(set) var horizontalStackView: UIStackView!
    private(set) var verticalStackView: UIStackView!
    
    //MARK: - Properties
    private var user: NLPUser!
    weak var delegate: MyPageHeaderViewDelegate?
    
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Mypage Data
    func configureUser(with user: NLPUser?) {
        guard let user = user,
              let currentUser = NLPUser.shared else { return }
        bioLabel.text = user.bio
        profilePhotoImageView.setImage(with: user.profilePhotoURL)
        user.email == currentUser.email ? (editProfileButton.isHidden = false) : (editProfileButton.isHidden = true)
    }
    
    //MARK: - Privates
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
    }
    
    private func configureStackView() {
        verticalStackView = UIStackView()
        addSubview(verticalStackView)
        
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        configureLayoutUI()
        
        configureHorizontalStackView()
        
        editProfileButton = NLPButton(title: "프로필 수정")
        editProfileButton.addTarget(self, action: #selector(didTappedEditProfileButton(_:)),
                                    for: .touchUpInside)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(editProfileButton)
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView = UIStackView()
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 16
        
        profilePhotoImageView = NLPProfilePhotoImageView(size: 100)
        bioLabel = NLPProfileLabel(type: .bio)
        
        horizontalStackView.addArrangedSubview(profilePhotoImageView)
        horizontalStackView.addArrangedSubview(bioLabel)
    }
    
    private func configureLayoutUI() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    @objc func didTappedEditProfileButton(_ sender: NLPButton) {
        delegate?.didTappedEditProfileButton(sender)
    }
}
