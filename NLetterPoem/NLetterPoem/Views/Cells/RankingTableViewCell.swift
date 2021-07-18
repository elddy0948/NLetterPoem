import UIKit

final class RankingTableViewCell: UITableViewCell {
    
    //MARK: ReuseIdentifier
    static let reuseIdentifier = String(describing: RankingTableViewCell.self)
    
    //MARK: - Views
    private(set) var stackView: UIStackView!
    private(set) var nicknameLabel: UILabel!
    private(set) var pointsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureStackView()
        configureNicknameLabel()
        configurePointsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {        
        stackView = UIStackView()
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.alignment = .center
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
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
        pointsLabel = UILabel()
        stackView.addArrangedSubview(pointsLabel)
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.textColor = .label
        pointsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        pointsLabel.textAlignment = .center
    }
    
    func setCellData(with user: NLPUser) {
        nicknameLabel.text = user.nickname
        pointsLabel.text = "\(user.points)"
    }
}
