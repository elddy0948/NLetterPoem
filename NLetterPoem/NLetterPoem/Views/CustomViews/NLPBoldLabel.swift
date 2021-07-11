import UIKit

final class NLPBoldLabel: UILabel {
    
    //MARK: - init
    init(size: CGFloat, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        configure(size: size, alignment: alignment)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(size: 16, alignment: .center)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(size: CGFloat, alignment: NSTextAlignment) {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        font = UIFont.systemFont(ofSize: size, weight: .bold)
        textAlignment = alignment
    }
}
