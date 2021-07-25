import UIKit

final class RankingTableViewCell: UITableViewCell {
    
    //MARK: ReuseIdentifier
    static let reuseIdentifier = String(describing: RankingTableViewCell.self)
    
    //MARK: - Views
    private(set) var rankingLabel: UILabel!
    private(set) var stackView: UIStackView!
    private(set) var nicknameLabel: UILabel!
    private(set) var firesLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        configureRankingLabel()
        configureStackView()
        configureNicknameLabel()
        configurePointsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRankingLabel() {
        rankingLabel = UILabel()
        contentView.addSubview(rankingLabel)
        
        rankingLabel.translatesAutoresizingMaskIntoConstraints = false
        rankingLabel.font = UIFont(name: "BM YEONSUNG", size: 42)
        rankingLabel.textColor = .white
        rankingLabel.text = "#1"
        
        NSLayoutConstraint.activate([
            rankingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rankingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            rankingLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureStackView() {
        let padding: CGFloat = 8
        stackView = UIStackView()
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
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
        
        if ranking == 0 {
            contentView.backgroundColor = UIColor(named: "NLPGold")
        } else if ranking == 1 {
            contentView.backgroundColor = UIColor(named: "NLPSilver")
        } else if ranking == 2 {
            contentView.backgroundColor = UIColor(named: "NLPBronze")
        } else {
            contentView.backgroundColor = .systemGreen
        }
        
        nicknameLabel.text = user.nickname
        firesLabel.text = "\(user.fires)"
    }
}
