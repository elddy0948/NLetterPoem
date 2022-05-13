import UIKit

final class NLPTabBarController: UITabBarController {
  
  static var tabBarTopAnchor: NSLayoutYAxisAnchor = NSLayoutYAxisAnchor()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.tintColor = .label
    let appearance = UITabBarAppearance()
    
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    
    self.tabBar.standardAppearance = appearance
    self.tabBar.isTranslucent = true
    
    if #available(iOS 15.0, *) {
      self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
    } else { }

    NLPTabBarController.tabBarTopAnchor = self.tabBar.topAnchor
  }
}
