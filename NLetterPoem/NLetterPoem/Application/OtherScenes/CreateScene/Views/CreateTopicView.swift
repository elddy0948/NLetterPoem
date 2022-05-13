import UIKit

protocol CreateTopicViewDelegate: AnyObject {
  func createTopicView(
    _ createTopicView: CreateTopicView,
    didTapNext topic: String?
  )
}

final class CreateTopicView: UIView {
  
  //MARK: - Views
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont(name: "BM YEONSUNG", size: 32)
    label.textColor = .label
    label.text = "주제를 입력해 주세요! \n ex) 자동차, 독서실"
    label.textAlignment = .center
    return label
  }()
  
  private lazy var topicTextField: UITextField = {
    let textField = UITextField()
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.layer.borderWidth = 3
    textField.layer.borderColor = UIColor.label.cgColor
    textField.layer.cornerRadius = 16
    
    textField.leftView = UIView(
      frame: CGRect(x: 0, y: 0, width: 8, height: 0)
    )
    textField.leftViewMode = .always
    
    return textField
  }()
  
  private lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "chevron.right.square"),
      for: .normal
    )
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    button.imageView?.contentMode = .scaleAspectFit
    button.imageView?.tintColor = .label
    button.addTarget(
      self, action: #selector(nextButtonAction(_:)),
      for: .touchUpInside
    )
    return button
  }()
  
  //MARK: - Properties
  weak var delegate: CreateTopicViewDelegate?
  
  //MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Configure Views
  private func configure() {
    backgroundColor = .systemBackground
    setupSubViews()
    layout()
  }
  
  private func setupSubViews() {
    topicTextField.delegate = self
  }
  
  private func layout() {
    let padding: CGFloat = 8
    
    self.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(topicTextField)
    self.addSubview(nextButton)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    topicTextField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(
        equalTo: centerYAnchor
      ),
      stackView.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: padding
      ),
      stackView.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -padding
      ),
      titleLabel.heightAnchor.constraint(
        equalToConstant: 90
      ),
      topicTextField.heightAnchor.constraint(
        equalToConstant: 48
      ),
      nextButton.centerXAnchor.constraint(
        equalTo: centerXAnchor
      ),
      nextButton.topAnchor.constraint(
        equalTo: stackView.bottomAnchor, constant: padding
      ),
      nextButton.widthAnchor.constraint(equalToConstant: 52),
      nextButton.heightAnchor.constraint(equalToConstant: 52),
    ])
  }
  
  @objc func nextButtonAction(_ sender: UIButton) {
    guard let topic = topicTextField.text else { return }
    if topic.isStringContainsSpecialCharacter() {
      delegate?.createTopicView(self, didTapNext: nil)
    } else {
      delegate?.createTopicView(self, didTapNext: topicTextField.text)
    }
  }
}

extension CreateTopicView: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    
    guard let inputText = textField.text,
          let rangeOfTextToReplace = Range(range, in: inputText) else {
      return false
    }
    
    let substringToReplace = inputText[rangeOfTextToReplace]
    let count = inputText.count - substringToReplace.count + string.count
    
    return count <= 6
  }
}
