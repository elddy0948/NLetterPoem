import UIKit

class MyPageCollectionViewCell: UICollectionViewCell {
  
  //MARK: - Statics
  static let reuseIdentifier = String(describing: MyPageCollectionViewCell.self)
  
  //MARK: - Views
  private(set) var backgroundImageView: UIImageView!
  private(set) var topicLabel: NLPYeonSungFontLabel!
  
  //MARK: - Properties
  var poem: Poem?
  
  //MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Configure Cell Data
  func setPoemData(with poemViewModel: Poem) {
    topicLabel.text = poemViewModel.topic
  }
  
  //MARK: - Configure Views
  private func configure() {
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
    configureBackgroundImageView()
    configureTopicLabel()
    configureLayoutUI()
  }
  
  private func configureBackgroundImageView() {
    backgroundImageView = UIImageView()
    contentView.addSubview(backgroundImageView)
    
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.image = UIImage(named: Constants.cellBackground)
    
    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
  
  private func configureTopicLabel() {
    topicLabel = NLPYeonSungFontLabel(size: 20, numberOfLines: 1, textAlignment: .center)
    backgroundImageView.addSubview(topicLabel)
    topicLabel.textAlignment = .center
  }
  
  private func configureLayoutUI() {
    let padding: CGFloat = 8
    NSLayoutConstraint.activate([
      topicLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: padding),
      topicLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: padding),
      topicLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -padding),
    ])
  }
}
