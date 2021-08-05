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
    private(set) var doneButton: UIButton!
    
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
        configureDoneButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTopicLabel()
        configureLabels()
        configureDoneButton()
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
    
    private func configureDoneButton() {
        let padding: CGFloat = 8
        doneButton = UIButton()
        addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        doneButton.contentHorizontalAlignment = .fill
        doneButton.contentVerticalAlignment = .fill
        doneButton.tintColor = .label
        
        doneButton.addTarget(self, action: #selector(didTappedDoneButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: lettersStackView.bottomAnchor, constant: padding),
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 52),
            doneButton.heightAnchor.constraint(equalToConstant: 52),
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
