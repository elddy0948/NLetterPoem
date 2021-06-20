import UIKit

class NLPButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configure(title: title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(title: "Some Title")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.systemGray.cgColor
    }
}
