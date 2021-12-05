import UIKit

final class HomeTableViewCell: UITableViewCell {
  
  //MARK: - Statics
  static let reuseIdentifier = String(describing: HomeTableViewCell.self)
  
  //MARK: - Views
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    return stackView
  }()
  
  private lazy var topicLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = UIFont(
      name: "BM YEONSUNG", size: 40
    )
    label.numberOfLines = 1
    return label
  }()
  
  private lazy var shortDescriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = UIFont(
      name: "BM YEONSUNG", size: 36
    )
    label.numberOfLines = 1
    return label
  }()
  
  private lazy var writerLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = UIFont(
      name: "BM YEONSUNG", size: 20
    )
    label.numberOfLines = 1
    label.textAlignment = .right
    return label
  }()
  
  //MARK: - Init
  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureContentView()
    setupStackView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let margins = UIEdgeInsets(
      top: 5, left: 5, bottom: 5, right: 5
    )
    contentView.frame = contentView.frame.inset(by: margins)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    topicLabel.text = nil
    shortDescriptionLabel.text = nil
    writerLabel.text = nil
  }
  
  private func configureContentView() {
    selectionStyle = .none
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
  }
  
  func setCellData(shortDes: String, writer: String, topic: String) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.shortDescriptionLabel.text = "\"\(shortDes)\""
      self.writerLabel.text = "-\(writer)-"
      self.topicLabel.text = topic
    }
  }
}

extension HomeTableViewCell {
  private func setupStackView() {
    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(topicLabel)
    stackView.addArrangedSubview(shortDescriptionLabel)
    stackView.addArrangedSubview(writerLabel)
    
    let margins = contentView.layoutMarginsGuide
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: margins.topAnchor),
      stackView.leadingAnchor.constraint(
        equalTo: margins.leadingAnchor),
      stackView.trailingAnchor.constraint(
        equalTo: margins.trailingAnchor),
      stackView.bottomAnchor.constraint(
        equalTo: margins.bottomAnchor),
    ])
  }
}
