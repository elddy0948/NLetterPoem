import UIKit

class NLPProfilePhotoImageView: UIImageView {
    
    //MARK: - Properties
    private let placeholder = SFSymbols.personCircle
    
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
        tintColor = .label
        
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    func setImage(with url: String) {
        if url.isEmpty {
            return
        }
        
        StorageManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
