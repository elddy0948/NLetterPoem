import UIKit

class MyPageView: UIView {
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var nicknameLabel: UILabel!
    private(set) var bioLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Privates
    private func configure() {
        profilePhotoImageView = NLPProfilePhotoImageView(frame: .zero)
        addSubview(profilePhotoImageView)
        backgroundColor = .systemGreen
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutUI() {
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            profilePhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
