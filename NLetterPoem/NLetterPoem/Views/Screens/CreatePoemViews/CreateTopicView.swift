import UIKit

protocol CreateTopicViewDelegate: AnyObject {
  func createTopicView(_ createTopicView: CreateTopicView, didTapNext topic: String?)
}

final class CreateTopicView: UIView {
  
  //MARK: - Views
  private(set) var stackView: UIStackView!
  private(set) var titleLabel: UILabel!
  private(set) var topicTextField: UITextField!
  private(set) var nextButton: UIButton!
  
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
    
    configureStackView()
    configureTitleLabel()
    configureTopicTextField()
    configureNextButton()
  }
  
  private func configureStackView() {
    let padding: CGFloat = 4
    stackView = UIStackView()
    addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 8
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
    ])
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    stackView.addArrangedSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.numberOfLines = 2
    titleLabel.font = UIFont(name: "BM YEONSUNG", size: 32)
    titleLabel.textColor = .label
    titleLabel.text = "주제를 입력해 주세요! \n ex) 자동차, 독서실"
    titleLabel.textAlignment = .center
    
    titleLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
  }
  
  private func configureTopicTextField() {
    topicTextField = UITextField()
    stackView.addArrangedSubview(topicTextField)
    
    topicTextField.translatesAutoresizingMaskIntoConstraints = false
    topicTextField.autocorrectionType = .no
    topicTextField.autocapitalizationType = .none
    topicTextField.layer.borderWidth = 3
    topicTextField.layer.borderColor = UIColor.label.cgColor
    topicTextField.layer.cornerRadius = 16
    topicTextField.delegate = self
    
    topicTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
    topicTextField.leftViewMode = .always
    
    topicTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
  }
  
  private func configureNextButton() {
    let padding: CGFloat = 8
    nextButton = UIButton()
    addSubview(nextButton)
    
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.setImage(UIImage(systemName: "chevron.right.square"), for: .normal)
    nextButton.contentHorizontalAlignment = .fill
    nextButton.contentVerticalAlignment = .fill
    nextButton.imageView?.contentMode = .scaleAspectFit
    nextButton.imageView?.tintColor = .label
    nextButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      nextButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
      nextButton.widthAnchor.constraint(equalToConstant: 52),
      nextButton.heightAnchor.constraint(equalToConstant: 52),
    ])
  }
  
  @objc func nextButtonAction(_ sender: UIButton) {
    delegate?.createTopicView(self, didTapNext: topicTextField.text)
  }
}

extension CreateTopicView: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    guard let inputText = textField.text,
          let rangeOfTextToReplace = Range(range, in: inputText) else {
      return false
    }
    let substringToReplace = inputText[rangeOfTextToReplace]
    let count = inputText.count - substringToReplace.count + string.count
    return count <= 6
  }
}
