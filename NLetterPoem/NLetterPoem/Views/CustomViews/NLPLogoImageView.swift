import UIKit

class NLPLogoImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        image = UIImage(named: Constants.logoImage)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
