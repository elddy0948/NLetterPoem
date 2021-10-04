import UIKit

class NLPBarButton: UIButton {
  
  init(text: String) {
    super.init(frame: .zero)
    createBarButtonItem(text: text)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createBarButtonItem(text: "")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func createBarButtonItem(text: String) {
    translatesAutoresizingMaskIntoConstraints = false
    
    let attributes = [
      NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits: [.traitBold]),
      NSAttributedString.Key.foregroundColor: UIColor.label
    ]
    let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    
    setAttributedTitle(attributedText, for: .normal)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
  }
}
