import UIKit

class NLPYeonSungFontLabel: UILabel {
  
  
  //MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure(size: 24, numberOfLines: 0, textAlignment: .center)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(size: CGFloat, numberOfLines: Int, textAlignment: NSTextAlignment) {
    super.init(frame: .zero)
    configure(size: size, numberOfLines: numberOfLines, textAlignment: textAlignment)
  }
  
  private func configure(size: CGFloat, numberOfLines: Int, textAlignment: NSTextAlignment) {
    translatesAutoresizingMaskIntoConstraints = false
    font = UIFont(name: "BM YEONSUNG", size: size)
    self.numberOfLines = numberOfLines
    self.textAlignment = textAlignment
    textColor = .label
  }
}
