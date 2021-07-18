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
        configureStackView()
        configureNicknameLabel()
        configurePointsLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        let padding: CGFloat = 8
        
        stackView = UIStackView()
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    private func configureNicknameLabel() {
        nicknameLabel = UILabel()
        stackView.addArrangedSubview(nicknameLabel)
        
        nicknameLabel.textColor = .label
        nicknameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nicknameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func configurePointsLabel() {
        pointsLabel = UILabel()
        stackView.addArrangedSubview(pointsLabel)
        
        pointsLabel.textColor = .label
        pointsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        pointsLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    func setCellData(with user: NLPUser) {
        nicknameLabel.text = user.nickname
        pointsLabel.text = "\(user.points)"
    }
}
