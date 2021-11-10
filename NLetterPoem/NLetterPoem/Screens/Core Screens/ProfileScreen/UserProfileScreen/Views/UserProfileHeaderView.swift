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
    layout()
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
    configureHeaderVerticalStackView()
    configureProfileImageView()
    configureUsernameLabel()
    configureBioLabel()
    configureRankHorizontalStackView()
    configureRankImageView()
    configureFiresLabel()
  }
}

//MARK: - Configure Views
extension UserProfileHeaderView {
  private func configureHeaderVerticalStackView() {
    verticalStackView = UIStackView()
    
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .equalSpacing
    verticalStackView.spacing = 4
  }
  
  private func configureProfileImageView() {
    profileImageView = UIImageView()
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFit
    profileImageView.image = UIImage(named: Constants.profileImage)
  }
  
  private func configureUsernameLabel() {
    userNameLabel = NLPProfileLabel(type: .nickname)
  }
  
  private func configureBioLabel() {
    bioLabel = NLPProfileLabel(type: .bio)
    bioLabel.translatesAutoresizingMaskIntoConstraints = true
  }
  
  private func configureRankHorizontalStackView() {
    rankHorizontalStackView = UIStackView()
    
    rankHorizontalStackView.axis = .horizontal
    rankHorizontalStackView.distribution = .fill
  }
  
  private func configureRankImageView() {
    rankImageView = UIImageView()
    rankImageView.translatesAutoresizingMaskIntoConstraints = false
    rankImageView.image = nil
    rankImageView.tintColor = .label
    rankImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    rankImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
  
  private func configureFiresLabel() {
    firesLabel = UILabel()
    firesLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
    firesLabel.textColor = .label
    firesLabel.textAlignment = .right
    firesLabel.text = "🔥"
  }
}

//MARK: - Layout
extension UserProfileHeaderView {
  private func layout() {
    let padding: CGFloat = 4
    addSubview(profileImageView)
    addSubview(userNameLabel)
    addSubview(verticalStackView)
    rankHorizontalStackView.addArrangedSubview(rankImageView)
    rankHorizontalStackView.addArrangedSubview(firesLabel)
    verticalStackView.addArrangedSubview(bioLabel)
    verticalStackView.addArrangedSubview(rankHorizontalStackView)
    
    
    NSLayoutConstraint.activate([
      //Profile ImageView
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      profileImageView.heightAnchor.constraint(equalToConstant: 50),
      profileImageView.widthAnchor.constraint(equalToConstant: 50),
      //Username Label
      userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: padding),
      userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      userNameLabel.heightAnchor.constraint(equalToConstant: 50),
      //Bio
      bioLabel.heightAnchor.constraint(equalToConstant: 80),
      //Rank HorizontalStackView
      rankHorizontalStackView.heightAnchor.constraint(equalToConstant: 30),
      //VerticalStackView
      verticalStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding),
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(padding * 2)),
    ])
  }
}
