import UIKit

extension UIFont {
  func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
      return UIFont()
    }
    return UIFont(descriptor: descriptor, size: 0)
  }
  
  func bold() -> UIFont {
    return withTraits(traits: .traitBold)
  }
}
