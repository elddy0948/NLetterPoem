import UIKit

class NLPCheckBoxButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderColor = UIColor.label.cgColor
    layer.borderWidth = 2
    layer.masksToBounds = true
    setTitle(nil, for: .normal)
    setTitle("✔", for: .selected)
  }
}
