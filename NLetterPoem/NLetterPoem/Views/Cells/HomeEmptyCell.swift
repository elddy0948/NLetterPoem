import UIKit


class HomeEmptyCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: HomeEmptyCell.self)
    
    private let emptyStateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(emptyStateLabel)
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.font = UIFont(name: "BM YEONSUNG", size: 42)
        emptyStateLabel.text = "😅\n오늘은 시가 없네요!"
        emptyStateLabel.textColor = .label
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            emptyStateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
