import UIKit

class NLPProfileLabel: UILabel {
    
    //MARK: - LabelType
    enum LabelType {
        case nickname
        case bio
        case normal
    }
    
    init(type: LabelType, text: String = "") {
        super.init(frame: .zero)
        configure(with: type, text: text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(with: .normal, text: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with type: LabelType, text: String) {
        textColor = .label
        self.text = text
        translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .nickname:
            font = UIFont.systemFont(ofSize: 40, weight: .bold)
            numberOfLines = 1
        case .bio:
            font = UIFont.systemFont(ofSize: 12, weight: .medium)
            numberOfLines = 3
        default:
            font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
}
