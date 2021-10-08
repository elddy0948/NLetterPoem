import UIKit

class NLPTabBarController: UITabBarController {
  
  static var tabBarTopAnchor: NSLayoutYAxisAnchor = NSLayoutYAxisAnchor()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.tintColor = .label
    
    NLPTabBarController.tabBarTopAnchor = self.tabBar.topAnchor
    
    viewControllers = [createHomeNavigaionController(),
                       createRankingNavigationController(),
                       createMyPageNavigationController()]
  }
  
  private func createHomeNavigaionController() -> UINavigationController {
    let viewController = HomeViewController()
    viewController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.houseFill, tag: 0)
    return UINavigationController(rootViewController: viewController)
  }
  
  private func createRankingNavigationController() -> UINavigationController {
    let viewController = RankingViewController()
    viewController.title = "🏆"
    viewController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.crownFill, tag: 1)
    return UINavigationController(rootViewController: viewController)
  }
  
  private func createMyPageNavigationController() -> UINavigationController {
    let viewController = MyPageViewController()
    viewController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.personFill, tag: 2)
    return UINavigationController(rootViewController: viewController)
  }
}
