import UIKit

final class DetailPoemView: UIView {
    
    //MARK: - Views
    private(set) var titleLabel: NLPBoldLabel!
    private(set) var authorLabel: NLPBoldLabel!
    private(set) var poemLabel: NLPBoldLabel!
    private(set) var fireButton: UIButton!
    
    //MARK: - init
    init(poem: NLPPoem) {
        super.init(frame: .zero)
        configure()
        setPoem(poem)
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
        configureTitleLabel()
        configureAuthorLabel()
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
    
    private func configureAuthorLabel() {
        let padding: CGFloat = 16
        
        authorLabel = NLPBoldLabel(size: 16, alignment: .right)
        addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func configurePoemLabel() {
        let padding: CGFloat = 32
        
        poemLabel = NLPBoldLabel(size: 24, alignment: .left)
        addSubview(poemLabel)
        
        poemLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            poemLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: padding),
            poemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            poemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureFireButton() {
        let padding: CGFloat = 16
        fireButton = UIButton()
        addSubview(fireButton)
        
        fireButton.translatesAutoresizingMaskIntoConstraints = false
        fireButton.setTitle("🔥", for: .normal)
        
        NSLayoutConstraint.activate([
            fireButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            fireButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fireButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setPoem(_ poem: NLPPoem) {
        titleLabel.text = poem.topic
        authorLabel.text = "-\(poem.author)-"
        poemLabel.text = poem.content
    }
}
