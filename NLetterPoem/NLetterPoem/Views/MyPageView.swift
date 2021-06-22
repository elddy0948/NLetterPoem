import UIKit

class MyPageView: UIView {
    
    //MARK: - Views
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var nicknameLabel: UILabel!
    private(set) var bioLabel: UILabel!
    
    //MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureProfilePhotoImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        backgroundColor = .systemGreen
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureProfilePhotoImageView() {
        let padding: CGFloat = 16
        profilePhotoImageView = NLPProfilePhotoImageView(size: 150)
        addSubview(profilePhotoImageView)
        
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
        ])
        
        print(profilePhotoImageView.frame.width)
    }
}
