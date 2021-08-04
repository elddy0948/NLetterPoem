import UIKit

protocol CreatePoemViewDelegate: AnyObject {
    func createPoemView(_ createPoemView: CreatePoemView, didCancel button: UIBarButtonItem)
    func createPoemView(_ createPoemView: CreatePoemView, didTapDone button: UIBarButtonItem, poem: String)
}

final class CreatePoemView: UIView {
    
    //MARK: - Views
    private(set) var topicLabel: UILabel!
    private(set) var lettersStackView: UIStackView!
    private(set) var inputViews: [NLPPoemFormView]!
    
    //MARK: - Properties
    var topic: String?
    var poem: NLPPoem?
    weak var delegate: CreatePoemViewDelegate?
    
    //MARK: - init
    init(topic: String, poem: NLPPoem?) {
        super.init(frame: .zero)
        self.topic = topic
        self.poem = poem
        
        configure()
        configureTopicLabel()
        configureLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTopicLabel()
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
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
            topicLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            topicLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            topicLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            topicLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func configureLabels() {
        guard let topic = topic else { return }
        let poemArray = poem?.content.makePoemArray()
        let topicArray = Array(topic)
        
        lettersStackView = UIStackView()
        inputViews = [NLPPoemFormView]()
        
        for letter in 0..<topicArray.count {
            let poemLetterView = NLPPoemFormView()
            poemLetterView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            poemLetterView.configureLetter(with: String(topicArray[letter]), line: poemArray?[letter])
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

    @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
        delegate?.createPoemView(self, didCancel: sender)
    }
    
    @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
        var poemString = ""
        
        for inputView in inputViews {
            let line = inputView.fetchLine() ?? ""
            poemString.append(line + "\n")
        }
        
        delegate?.createPoemView(self, didTapDone: sender, poem: poemString)
    }
}
