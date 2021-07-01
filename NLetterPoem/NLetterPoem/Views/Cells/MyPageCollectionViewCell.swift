import UIKit

class MyPageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Statics
    static let reuseIdentifier = String(describing: MyPageCollectionViewCell.self)
    
    //MARK: - Views
    private(set) var medalLabel: UILabel!
    private(set) var topicLabel: UILabel!
    
    //MARK: - Properties
    var poem: NLPPoem?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure Cell Data
    func setPoemData(with poem: NLPPoem?) {
        guard let poem = poem else { return }
        if poem.ranking == 1 {
            medalLabel.text = RankingState.gold.medal
            contentView.backgroundColor = RankingState.gold.backgroundColor
        } else if poem.ranking == 2 {
            medalLabel.text = RankingState.silver.medal
            contentView.backgroundColor = RankingState.silver.backgroundColor
        } else if poem.ranking == 3 {
            medalLabel.text = RankingState.bronze.medal
            contentView.backgroundColor = RankingState.bronze.backgroundColor
        } else {
            medalLabel.text = RankingState.none.medal
            contentView.backgroundColor = RankingState.none.backgroundColor
        }
        topicLabel.text = poem.topic
    }
    
    //MARK: - Configure Views
    private func configure() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        configureMedalLabel()
        configureTopicLabel()
        configureLayoutUI()
    }
    
    private func configureMedalLabel() {
        medalLabel = UILabel()
        contentView.addSubview(medalLabel)
        
        medalLabel.translatesAutoresizingMaskIntoConstraints = false
        medalLabel.font = UIFont.systemFont(ofSize: 36)
        medalLabel.textAlignment = .center
    }
    
    private func configureTopicLabel() {
        topicLabel = UILabel()
        contentView.addSubview(topicLabel)
        
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        topicLabel.textAlignment = .center
    }
    
    private func configureLayoutUI() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            medalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            medalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            medalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            topicLabel.topAnchor.constraint(equalTo: medalLabel.bottomAnchor, constant: padding),
            topicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            topicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            topicLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    enum RankingState: Int {
        case gold = 1
        case silver = 2
        case bronze = 3
        case none
        
        var backgroundColor: UIColor {
            switch self {
            case .gold:
                return UIColor(named: "NLPGold")!
            case .silver:
                return UIColor(named: "NLPSilver")!
            case .bronze:
                return UIColor(named: "NLPBronze")!
            case .none:
                return UIColor.systemGray
            }
        }
        
        var medal: String {
            switch self {
            case .gold:
                return "🥇"
            case .silver:
                return "🥈"
            case .bronze:
                return "🥉"
            case .none:
                return "📜"
            }
        }
    }
}
