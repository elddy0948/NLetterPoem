import UIKit

protocol EditProfileViewDelegate: AnyObject {
    func didTappedCancelButton(_ editProfileView: EditProfileView)
    func didTappedDoneButton(_ editProfileView: EditProfileView, with user: NLPUser)
    func didTappedImageView(_ editProfileView: EditProfileView)
}

class EditProfileView: UIView {
    
    //MARK: - Views
    private(set) var navigationBar: UINavigationBar!
    private(set) var profilePhotoImageView: NLPProfilePhotoImageView!
    private(set) var nicknameTextField: NLPTextField!
    private(set) var bioTextView: UITextView!
    
    //MARK: - Properties
    private var user: NLPUser!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    weak var delegate: EditProfileViewDelegate?
    
    //MARK: - init
    init(user: NLPUser) {
        super.init(frame: .zero)
        self.user = user
        configure()
        configureNavigationBar()
        configureProfilePhotoImageView()
        configureNicknameTextField()
        configureBioTextView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationBar() {
        navigationBar = UINavigationBar()
        addSubview(navigationBar)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.barTintColor = .systemBackground
        navigationBar.tintColor = .label
        
        configureNavigationItem()
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func configureNavigationItem() {
        let item = UINavigationItem(title: "프로필 수정")
        let cancelButton = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(didTappedCancelButton(_:)))
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTappedDoneButton(_:)))
        
        item.leftBarButtonItem = cancelButton
        item.rightBarButtonItem = doneButton
        
        navigationBar.pushItem(item, animated: true)
    }
    
    private func configureProfilePhotoImageView() {
        profilePhotoImageView = NLPProfilePhotoImageView(size: 100)
        profilePhotoImageView.setImage(with: user.profilePhotoURL)
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(didTappedImageView(_:)))
        profilePhotoImageView.addGestureRecognizer(tapGestureRecognizer)
        profilePhotoImageView.isUserInteractionEnabled = true
        addSubview(profilePhotoImageView)
        
        NSLayoutConstraint.activate([
            profilePhotoImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            profilePhotoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureNicknameTextField() {
        nicknameTextField = NLPTextField(type: .nickname)
        addSubview(nicknameTextField)
        nicknameTextField.text = user.nickname
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 16),
            nicknameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nicknameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func configureBioTextView() {
        bioTextView = UITextView()
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.text = user.bio
        bioTextView.backgroundColor = .secondarySystemBackground
        bioTextView.layer.borderColor = UIColor.systemGray.cgColor
        bioTextView.layer.borderWidth = 3
        bioTextView.layer.cornerRadius = 16
        bioTextView.layer.masksToBounds = true
        addSubview(bioTextView)
        
        NSLayoutConstraint.activate([
            bioTextView.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 16),
            bioTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bioTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bioTextView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func setProfileImage(with image: UIImage) {
        self.profilePhotoImageView.image = image
    }
    
    //MARK: - Actions
    @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
        delegate?.didTappedCancelButton(self)
    }
    
    @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
        guard let nickname = nicknameTextField.text,
              let bio = bioTextView.text,
              let profilePhoto = profilePhotoImageView.image,
              let imageData = profilePhoto.pngData(),
              let user = user else {
            delegate?.didTappedCancelButton(self)
            return
        }
        
        StorageManager.shared.uploadImage(with: imageData, email: user.email) { [weak self] url in
            guard let self = self else { return }
            if let url = url {
                user.profilePhotoURL = url.absoluteString
            }
            user.nickname = nickname
            user.bio = bio
            
            self.delegate?.didTappedDoneButton(self, with: user)
        }
    }
    
    @objc func didTappedImageView(_ sender: NLPProfilePhotoImageView) {
        delegate?.didTappedImageView(self)
    }
}
