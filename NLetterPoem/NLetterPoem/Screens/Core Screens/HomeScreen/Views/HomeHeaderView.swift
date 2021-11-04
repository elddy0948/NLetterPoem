import UIKit

final class HomeHeaderView: UIView {
  
  //MARK: - Views
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .label
    label.font = UIFont(name: "BM YEONSUNG", size: 36)
    label.textAlignment = .center
    label.text = "추천 주제"
    return label
  }()
  
  private lazy var topicLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .label
    label.font = UIFont(name: "BM YEONSUNG", size: 48)
    label.textAlignment = .center
    label.text = ""
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
    configureSubViews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureSubViews() {
    addSubview(titleLabel)
    addSubview(topicLabel)
  }
  
  func setTopic(_ topic: String) {
    topicLabel.text = topic
  }
  
  private func layout() {
    let padding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 40),
      
      topicLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      topicLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      topicLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      topicLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
    ])
  }
}
