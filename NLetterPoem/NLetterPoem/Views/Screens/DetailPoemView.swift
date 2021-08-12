import UIKit

protocol DetailPoemViewDelegate: AnyObject {
  func didTappedFireButton(_ detailPoemView: DetailPoemView,
                           _ fireButton: UIButton)
  func detailPoemView(_ view: DetailPoemView,
                      didTapAuthor author: String?)
}

final class DetailPoemView: UIView {
  
  //MARK: - Views
  private(set) var titleLabel: NLPBoldLabel!
  private(set) var authorButton: UIButton!
  private(set) var poemLabel: NLPBoldLabel!
  private(set) var fireButton: UIButton!
  
  //MARK: - Properties
  weak var delegate: DetailPoemViewDelegate?
  
  //MARK: - init
  init(poem: NLPPoem, fireState: Bool, enableAuthorButton: Bool) {
    super.init(frame: .zero)
    configure()
    setPoem(poem, fireState: fireState, enableAuthorButton: enableAuthorButton)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    backgroundColor = .systemBackground
    translatesAutoresizingMaskIntoConstraints = false
    
    configureTitleLabel()
    configureAuthorButton()
    configurePoemLabel()
    configureFireButton()
  }
  
  private func configureTitleLabel() {
    let padding: CGFloat = 16
    
    titleLabel = NLPBoldLabel(size: 36, alignment: .center)
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 40),
    ])
  }
  
  private func configureAuthorButton() {
    let padding: CGFloat = 16
    
    authorButton = UIButton()
    addSubview(authorButton)
    
    authorButton.translatesAutoresizingMaskIntoConstraints = false
    authorButton.tintColor = .label
    authorButton.setTitle("-author-", for: .normal)
    authorButton.setTitleColor(.label, for: .normal)
    
    authorButton.addTarget(self, action: #selector(authorButtonAction(_:)), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      authorButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      authorButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      authorButton.heightAnchor.constraint(equalToConstant: 20),
    ])
  }
  
  private func configurePoemLabel() {
    let padding: CGFloat = 32
    
    poemLabel = NLPBoldLabel(size: 24, alignment: .left)
    addSubview(poemLabel)
    
    poemLabel.numberOfLines = 0
    
    NSLayoutConstraint.activate([
      poemLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: padding),
      poemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      poemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
    ])
  }
  
  private func configureFireButton() {
    let padding: CGFloat = 16
    
    fireButton = UIButton()
    addSubview(fireButton)
    
    fireButton.translatesAutoresizingMaskIntoConstraints = false
    fireButton.setImage(SFSymbols.flame, for: .normal)
    fireButton.setImage(SFSymbols.flameFill, for: .selected)
    fireButton.tintColor = .label
    fireButton.contentHorizontalAlignment = .fill
    fireButton.contentVerticalAlignment = .fill
    
    fireButton.addTarget(self, action: #selector(didTappedFireButton(_:)), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      fireButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
      fireButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      fireButton.heightAnchor.constraint(equalToConstant: 50),
      fireButton.widthAnchor.constraint(equalToConstant: 50),
    ])
  }
  
  private func setPoem(_ poem: NLPPoem, fireState: Bool, enableAuthorButton: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.titleLabel.text = poem.topic
      self.authorButton.setTitle("-\(poem.author)-", for: .normal)
      self.poemLabel.text = poem.content
      self.fireButton.isSelected = fireState
      fireState ? (self.fireButton.tintColor = .systemRed) : (self.fireButton.tintColor = .label)
    }
    authorButton.isUserInteractionEnabled = enableAuthorButton
  }
  
  func updatePoem(with poem: NLPPoem?) {
    guard let poem = poem else { return }
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.poemLabel.text = poem.content
    }
  }
  
  //MARK: - Actions
  @objc func didTappedFireButton(_ sender: UIButton) {
    delegate?.didTappedFireButton(self,
                                  sender)
  }
  
  @objc func authorButtonAction(_ sender: UIButton) {
    delegate?.detailPoemView(self,
                             didTapAuthor: authorButton.title(for: .normal))
  }
}
