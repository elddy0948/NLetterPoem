import UIKit

extension UINavigationController {
  func configureNavigationBarAppearance(_ backgroundColor: UIColor) {
    let appearance = UINavigationBarAppearance()
    
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = backgroundColor
    appearance.shadowColor = .systemBackground
    
    self.navigationBar.standardAppearance = appearance
    self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
    self.navigationBar.isTranslucent = true
  }
}
