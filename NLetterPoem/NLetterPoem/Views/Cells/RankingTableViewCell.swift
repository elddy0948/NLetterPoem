import UIKit

final class RankingTableViewCell: UITableViewCell {
    
    //MARK: ReuseIdentifier
    static let reuseIdentifier = String(describing: RankingTableViewCell.self)
    
    //MARK: - Views
    private(set) var rankImageView: UIImageView!
    private(set) var stackView: UIStackView!
    private(set) var nicknameLabel: UILabel!
    private(set) var firesLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        configureStackView()
        configureRankImageView()
        configureNicknameLabel()
        configurePointsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        let padding: CGFloat = 8
        stackView = UIStackView()
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    private func configureRankImageView() {
        rankImageView = UIImageView()
        stackView.addArrangedSubview(rankImageView)
        
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        rankImageView.image = UIImage(systemName: "paintbrush.pointed.fill")
        rankImageView.tintColor = .label
        
        rankImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        rankImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    private func configureNicknameLabel() {
        nicknameLabel = UILabel()
        stackView.addArrangedSubview(nicknameLabel)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.textColor = .label
        nicknameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nicknameLabel.textAlignment = .center
    }
    
    private func configurePointsLabel() {
        firesLabel = UILabel()
        stackView.addArrangedSubview(firesLabel)
        
        firesLabel.translatesAutoresizingMaskIntoConstraints = false
        firesLabel.textColor = .label
        firesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        firesLabel.textAlignment = .center
    }
    
    func setCellData(with user: NLPUser, ranking: Int) {
        nicknameLabel.text = user.nickname
        firesLabel.text = "\(user.fires)🔥"
    }
}
