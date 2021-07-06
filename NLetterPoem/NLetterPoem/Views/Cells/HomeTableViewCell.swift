import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    //MARK: - Statics
    static let reuseIdentifier = String(describing: HomeTableViewCell.self)
    
    //MARK: - Views
    private(set) var shortDescriptionLabel: UILabel!
    private(set) var writerLabel: UILabel!
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
        configureShortDescriptionLabel()
        configureWriterLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.label.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shortDescriptionLabel.text = nil
        writerLabel.text = nil
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 3
    }
    
    private func configureShortDescriptionLabel() {
        let padding: CGFloat = 8
        
        shortDescriptionLabel = UILabel()
        contentView.addSubview(shortDescriptionLabel)
        
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.textColor = .label
        shortDescriptionLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        shortDescriptionLabel.numberOfLines = 1
        shortDescriptionLabel.text = ""
        
        NSLayoutConstraint.activate([
            shortDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            shortDescriptionLabel.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    private func configureWriterLabel() {
        let padding: CGFloat = 8
        
        writerLabel = UILabel()
        contentView.addSubview(writerLabel)
        
        writerLabel.translatesAutoresizingMaskIntoConstraints = false
        writerLabel.textColor = .label
        writerLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        writerLabel.numberOfLines = 0
        writerLabel.text = ""
        
        NSLayoutConstraint.activate([
            writerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            writerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    func setCellData(shortDes: String, writer: String) {
        shortDescriptionLabel.text = shortDes
        writerLabel.text = writer
    }
}
