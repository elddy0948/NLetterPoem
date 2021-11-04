import UIKit

final class UserProfileHeaderView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: UserProfileHeaderView.self)
  
  //MARK: - Views
  private(set) var profileImageView: UIImageView!
  private(set) var userNameLabel: NLPProfileLabel!
  private(set) var bioLabel: NLPProfileLabel!
  private(set) var rankHorizontalStackView: UIStackView!
  private(set) var rankImageView: UIImageView!
  private(set) var firesLabel: UILabel!
  private(set) var verticalStackView: UIStackView!
  
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
  func configureUser(with user: ProfileUserViewModel) {
    bioLabel.text = user.bio
    userNameLabel.text = user.nickname
    firesLabel.text = "\(user.fires)🔥"
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
    
    configureProfileImageView()
    configureUsernameLabel()
    configureBioLabel()
    configureLayoutUI()
    configureRankStackView()
  }
  
  private func configureProfileImageView() {
    profileImageView = UIImageView()
    addSubview(profileImageView)
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFit
    profileImageView.image = UIImage(named: Constants.profileImage)
  }
  
  private func configureUsernameLabel() {
    userNameLabel = NLPProfileLabel(type: .nickname)
    addSubview(userNameLabel)
  }
  
  private func configureRankStackView() {
    rankHorizontalStackView = UIStackView()
    verticalStackView.addArrangedSubview(rankHorizontalStackView)
    
    rankHorizontalStackView.axis = .horizontal
    rankHorizontalStackView.distribution = .fill
    
    rankImageView = UIImageView()
    rankImageView.translatesAutoresizingMaskIntoConstraints = false
    rankImageView.image = nil
    rankImageView.tintColor = .label
    rankImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    rankImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    firesLabel = UILabel()
    firesLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    firesLabel.textColor = .label
    firesLabel.textAlignment = .right
    firesLabel.text = "🔥"
    
    rankHorizontalStackView.addArrangedSubview(rankImageView)
    rankHorizontalStackView.addArrangedSubview(firesLabel)
  }
  
  private func configureBioLabel() {
    bioLabel = NLPProfileLabel(type: .bio)
    verticalStackView.addArrangedSubview(bioLabel)
  }
  
  private func configureLayoutUI() {
    let padding: CGFloat = 16
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      profileImageView.heightAnchor.constraint(equalToConstant: 50),
      profileImageView.widthAnchor.constraint(equalToConstant: 50),
      userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: padding),
      userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding / 2),
      userNameLabel.heightAnchor.constraint(equalToConstant: 48),
      verticalStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding),
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
    ])
  }
}
