import UIKit

protocol CreatePoemViewDelegate: AnyObject {
  func createPoemView(
    _ createPoemView: CreatePoemView,
    didCancel button: UIBarButtonItem
  )
  func createPoemView(
    _ createPoemView: CreatePoemView,
    didTapDone button: UIBarButtonItem,
    poemContent: String
  )
  func createPoemView(
    _ createPoemView: CreatePoemView,
    emptyFieldExist message: String
  )
  func createPoemView(
    _ createPoemView: CreatePoemView,
    specialCharacterExist message: String
  )
}

final class CreatePoemView: UIView {
  
  //MARK: - Views
  private lazy var topicLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.textAlignment = .center
    return label
  }()
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    return stackView
  }()
  private lazy var inputViews: [NLPPoemFormView] = []
  private lazy var doneButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "checkmark.circle"),
      for: .normal
    )
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    button.tintColor = .label
    button.addTarget(
      self,
      action: #selector(didTappedDoneButton(_:)),
      for: .touchUpInside
    )
    return button
  }()
  
  //MARK: - Properties
  var poem: Poem?
  weak var delegate: CreatePoemViewDelegate?
  
  //MARK: - init
  init(poem: Poem?) {
    super.init(frame: .zero)
    self.poem = poem
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureLabels() {
    guard let poem = poem else { return }

    let poemArray = poem.content.makePoemArray()
    let topicArray = poem.topic.map{ String($0) }
    
    for index in 0 ..< topicArray.count {
      let poemLetterView = NLPPoemFormView()
      
      poemLetterView.heightAnchor.constraint(
        equalToConstant: 50
      ).isActive = true
      poemLetterView.configureLetter(
        with: topicArray[index], line: poemArray[index]
      )
      inputViews.append(poemLetterView)
      contentStackView.addArrangedSubview(poemLetterView)
    }
  }
  
  @objc func didTappedCancelButton(_ sender: UIBarButtonItem) {
    delegate?.createPoemView(self, didCancel: sender)
  }
  
  @objc func didTappedDoneButton(_ sender: UIBarButtonItem) {
    var poemString = ""
    
    for inputView in inputViews {
      guard let line = inputView.fetchLine() else {
        delegate?.createPoemView(self, emptyFieldExist: "빈칸이 존재합니다!")
        return
      }
      if line.isStringContainsSpecialCharacter() {
        delegate?.createPoemView(self, specialCharacterExist: "특수문자가 존재합니다!")
        return
      }
      poemString.append(line + "\n")
    }
    
    delegate?.createPoemView(self, didTapDone: sender, poemContent: poemString)
  }
}

//MARK: - Layout
extension CreatePoemView {
  private func layout() {
    let padding: CGFloat = 8
    
    self.addSubview(topicLabel)
    self.addSubview(contentStackView)
    self.addSubview(doneButton)
    
    topicLabel.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      topicLabel.topAnchor.constraint(
        equalTo: safeAreaLayoutGuide.topAnchor, constant: padding
      ),
      topicLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: padding
      ),
      topicLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -padding
      ),
      topicLabel.heightAnchor.constraint(equalToConstant: 80),
      doneButton.bottomAnchor.constraint(
        equalTo: bottomAnchor, constant: -padding
      ),
      doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      doneButton.widthAnchor.constraint(equalToConstant: 52),
      doneButton.heightAnchor.constraint(equalToConstant: 52),
      contentStackView.topAnchor.constraint(
        equalTo: topicLabel.bottomAnchor, constant: padding
      ),
      contentStackView.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: padding
      ),
      contentStackView.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -padding
      ),
      contentStackView.bottomAnchor.constraint(
        equalTo: doneButton.topAnchor, constant: -padding
      )
    ])
  }
}
