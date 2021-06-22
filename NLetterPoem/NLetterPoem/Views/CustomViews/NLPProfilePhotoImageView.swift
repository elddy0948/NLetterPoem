import UIKit

class NLPProfilePhotoImageView: UIImageView {
    
    //MARK: - Properties
    private let placeholder = UIImage(systemName: SFSymbols.personCircle)
    
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        image = placeholder
        
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        
        backgroundColor = .systemGray
    }
}
