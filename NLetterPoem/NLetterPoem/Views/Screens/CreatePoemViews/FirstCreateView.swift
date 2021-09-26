import UIKit

protocol FirstCreateViewDelegate: AnyObject {
  func firstCreateView(_ firstCreateView: FirstCreateView, didTapCheckBox checkBoxButton: NLPCheckBoxButton, nextButton: UIButton)
  func firstCreateView(_ firstCreateView: FirstCreateView, didTapNextButton nextButton: UIButton)
}

class FirstCreateView: UIView {
  
  private(set) var titleLabel: UILabel!
  private(set) var commentLabel: UILabel!
  private(set) var checkBoxButton: NLPCheckBoxButton!
  private(set) var nextButton: UIButton!
  
  weak var delegate: FirstCreateViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    configureTitleLabel()
    configureCommentLabel()
    configureCheckBoxButton()
    configureNextButton()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .label
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.text = "환영합니다!"
    titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
  }
  
  private func configureCommentLabel() {
    commentLabel = UILabel()
    addSubview(commentLabel)
    
    commentLabel.translatesAutoresizingMaskIntoConstraints = false
    commentLabel.textColor = .label
    commentLabel.textAlignment = .left
    commentLabel.font = UIFont.preferredFont(forTextStyle: .title3)
    commentLabel.numberOfLines = 0
    commentLabel.text = """
  첫번째 시 작성을 환영합니다
  
  ⚠️타인에게 불쾌감을 줄 수 있는 게시물을 작성할 시 'N행시인' 사용에 불이익을 얻을 수 있습니다.
  ⚠️지속적인 불쾌감을 주는 게시물로 신고가 누적되면 게시물 삭제 / 계정 차단이 될 수 있습니다.
  
  최초 동의시 앞으로 작성하시는 '모든' 게시물에 적용됩니다.
  
  동의하시면 아래의 체크박스를 체크해주세요!
  """
  }
  
  private func configureCheckBoxButton() {
    checkBoxButton = NLPCheckBoxButton()
    addSubview(checkBoxButton)
    checkBoxButton.addTarget(self, action: #selector(checkBoxAction(_:)), for: .touchUpInside)
  }
  
  private func configureNextButton() {
    nextButton = UIButton()
    addSubview(nextButton)
    
    nextButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
    
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.isEnabled = false
    nextButton.setTitle("다음", for: .normal)
    nextButton.setTitleColor(.label, for: .normal)
    nextButton.setTitleColor(.systemGray, for: .disabled)
  }
  
  //MARK: - Actions
  @objc func checkBoxAction(_ sender: NLPCheckBoxButton) {
    delegate?.firstCreateView(self, didTapCheckBox: sender, nextButton: nextButton)
  }
  
  @objc func nextButtonAction(_ sender: UIButton) {
    delegate?.firstCreateView(self, didTapNextButton: sender)
  }
}

//MARK: - Layout
extension FirstCreateView {
  private func layout() {
    let padding: CGFloat = 16
    
    NSLayoutConstraint.activate([
      //Title Label
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

      //Comment Label
      commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 2),
      commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      
      //CheckBoxButton
      checkBoxButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: padding),
      checkBoxButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      checkBoxButton.heightAnchor.constraint(equalToConstant: 30),
      checkBoxButton.widthAnchor.constraint(equalToConstant: 30),
      
      //NextButton
      nextButton.topAnchor.constraint(equalTo: checkBoxButton.bottomAnchor, constant: padding),
      nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      nextButton.heightAnchor.constraint(equalToConstant: 50),
      nextButton.widthAnchor.constraint(equalToConstant: 50),
    ])
  }
}
