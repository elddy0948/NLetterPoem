import UIKit

// 참여 횟수
// 1위 횟수
// 2위 횟수
// 3위 횟수

class NLPProfileCardView: UIView {
    private(set) var cardTitleImageView: UIImageView!
    private(set) var cardImageView: UIImageView!
    private(set) var countLabel: UILabel!
    
    private var cardType: CardType!
    
    //MARK: - init
    init(type: CardType) {
        super.init(frame: .zero)
        cardType = type
        configure()
        configureCardTitleImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCardTitleImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        backgroundColor = cardType.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    private func configureCardTitleImageView() {
        let padding: CGFloat = 8
        cardTitleImageView = UIImageView(image: cardType.title)
        cardTitleImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardTitleImageView)
        
        NSLayoutConstraint.activate([
            cardTitleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardTitleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            cardTitleImageView.widthAnchor.constraint(equalToConstant: 50),
            cardTitleImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    //MARK: - CardType
    enum CardType {
        case participation
        case firstPlace
        case secondPlace
        case thirdPlace
        
        var title: UIImage {
            switch self {
            case .participation:
                return UIImage(systemName: "text.badge.plus")?.withTintColor(.white) ?? UIImage()
            case .firstPlace:
                return UIImage(named: "FirstPlaceTitle") ?? UIImage()
            case .secondPlace:
                return UIImage(named: "SecondPlaceTitle") ?? UIImage()
            case .thirdPlace:
                return UIImage(named: "ThirdPlaceTitle") ?? UIImage()
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .participation:
                return .black
            case .firstPlace:
                return UIColor(named: "NLPGold") ?? .systemBackground
            case .secondPlace:
                return UIColor(named: "NLPSilver") ?? .systemBackground
            case .thirdPlace:
                return UIColor(named: "NLPBronze") ?? .systemBackground
            }
        }
    }
}
