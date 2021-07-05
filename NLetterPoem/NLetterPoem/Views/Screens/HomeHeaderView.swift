import UIKit

final class HomeHeaderView: UIView {
    
    //MARK: - Views
    private(set) var titleLabel: UILabel!
    private(set) var topicLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
        configureTopicLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 16
        layer.borderWidth = 3
        layer.masksToBounds = true
    }
    
    private func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.textColor = .label
        titleLabel.font = UIFont(name: "NanumBrush", size: 32)
        titleLabel.textAlignment = .center
        titleLabel.text = "오늘의 주제"
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTopicLabel() {
        topicLabel = UILabel()
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topicLabel)
        
        topicLabel.textColor = .label
        topicLabel.font = UIFont(name: "NanumBrush", size: 48)
        topicLabel.textAlignment = .center
        topicLabel.text = ""
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            topicLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            topicLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topicLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            topicLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    func setTopic(_ topic: String) {
        topicLabel.text = topic
    }
}
