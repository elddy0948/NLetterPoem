import UIKit

protocol CreatePoemViewDelegate: AnyObject {
    func didTappedCancelButton(_ createPoemView: CreatePoemView)
    func didTappedDoneButton(_ createPoemView: CreatePoemView, with poem: String)
}

final class CreatePoemView: UIView {
    
    //MARK: - Views
    private(set) var navigationBar: UINavigationBar!
    private(set) var topicLabel: UILabel!
    private(set) var lettersStackView: UIStackView!
    private(set) var inputViews: [NLPPoemFormView]!
    
    //MARK: - Properties
    var topic: String?
    weak var delegate: CreatePoemViewDelegate?
    
    //MARK: - init
    init(topic: String) {
        super.init(frame: .zero)
        self.topic = topic
        configure()
        configureNavigationBar()
        configureTopicLabel()
        configureLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureNavigationBar()
        configureTopicLabel()
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
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
    
    private func configureTopicLabel() {
        topicLabel = UILabel()
        addSubview(topicLabel)
        
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.textColor = .label
        topicLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        topicLabel.text = topic
        topicLabel.textAlignment = .center
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            topicLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: padding),
            topicLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            topicLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            topicLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func configureLabels() {
        guard let topic = topic else { return }
        lettersStackView = UIStackView()
        inputViews = [NLPPoemFormView]()
        
        for letter in topic {
            let poemLetterView = NLPPoemFormView()
            poemLetterView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            poemLetterView.configureLetter(with: String(letter))
            inputViews.append(poemLetterView)
            lettersStackView.addArrangedSubview(poemLetterView)
        }
        
        addSubview(lettersStackView)
        
        lettersStackView.axis = .vertical
        lettersStackView.distribution = .fill
        lettersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            lettersStackView.topAnchor.constraint(equalTo: topicLabel.bottomAnchor,
                                                  constant: padding),
            lettersStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: padding),
            lettersStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -padding),
        ])
    }
    
    private func configureNavigationItem() {
        let item = UINavigationItem(title: "시 작성하기")
        let cancelButton = UIBarButtonItem(title: "닫기", style: .plain,
                                           target: self, action: #selector(didTappedCancelButton(_:)))
        let doneButton = UIBarButtonItem(title: "완료", style: .done,
                                         target: self, action: #selector(didTappedDoneButton(_:)))
        
        item.leftBarButtonItem = cancelButton
        item.rightBarButtonItem = doneButton
        
        navigationBar.pushItem(item, animated: true)
    }
    
    @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
        delegate?.didTappedCancelButton(self)
    }
    
    @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
        var poemString = ""
        
        for inputView in inputViews {
            let line = inputView.fetchLine() ?? ""
            poemString.append(line + "\n")
        }
        
        delegate?.didTappedDoneButton(self, with: poemString)
    }
}
