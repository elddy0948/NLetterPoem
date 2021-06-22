import UIKit

class NLPProfilePhotoImageView: UIImageView {
    
    //MARK: - Properties
    private let placeholder = UIImage(systemName: SFSymbols.personCircle)
    
    //MARK: - initializer
    init(size: CGFloat) {
        super.init(frame: .zero)
        configure(with: size)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(with: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure(with size: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        image = placeholder
        
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
}
