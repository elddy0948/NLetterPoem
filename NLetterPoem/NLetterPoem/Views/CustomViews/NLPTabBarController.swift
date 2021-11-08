import UIKit

class NLPTabBarController: UITabBarController {
  
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
    
    viewControllers = [createHomeNavigaionController(),
                       createSearchNavigationController(),
                       createRankingNavigationController(),
                       createMyPageNavigationController()]
  }
  
  private func createHomeNavigaionController() -> UINavigationController {
    let viewController = HomeViewController()
    let navController = UINavigationController(rootViewController: viewController)
    navController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.houseFill, tag: 0)
    navController.configureNavigationBarAppearance(.systemBackground)
    return navController
  }
  
  private func createSearchNavigationController() -> UINavigationController {
    let viewController = SearchViewController()
    let navController = UINavigationController(rootViewController: viewController)
    viewController.title = "주제 검색"
    navController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.magnifyingglass, tag: 1)
    navController.configureNavigationBarAppearance(.systemBackground)
    return navController
  }
  
  private func createRankingNavigationController() -> UINavigationController {
    let viewController = RankingViewController()
    let navController = UINavigationController(rootViewController: viewController)
    viewController.title = "N행시 달인"
    navController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.crownFill, tag: 2)
    navController.configureNavigationBarAppearance(.systemBackground)
    return navController
  }
  
  private func createMyPageNavigationController() -> UINavigationController {
    let viewController = MyPageViewController()
    let navController = UINavigationController(rootViewController: viewController)
    viewController.title = "마이페이지"
    navController.tabBarItem = UITabBarItem(title: nil, image: SFSymbols.personFill, tag: 3)
    navController.configureNavigationBarAppearance(.systemBackground)
    return navController
  }
}
