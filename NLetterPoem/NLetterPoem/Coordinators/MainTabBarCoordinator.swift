import UIKit

final class MainTabBarCoordinator: Coordinator {
  var children: [Coordinator] = []
  var router: Router
  
  init(router: Router) {
    self.router = router
  }
  
  func present(animated: Bool,
               onDismissed: (() -> Void)?) {
    guard let router = router as? TabBarRouter else {
      return
    }
    
    let homeViewController = createHomeNavigaionController()
    let searchViewController = createSearchNavigationController()
    let rankingViewController = createRankingNavigationController()
    let profileViewController = createMyPageNavigationController()
    
    router.present(
      [
        homeViewController,
        searchViewController,
        rankingViewController,
        profileViewController
      ],
      animated: true,
      onDismissed: nil
    )
  }
  
  func dismiss(animated: Bool) {
  }
}

extension MainTabBarCoordinator {
  private func createHomeNavigaionController(
  ) -> UINavigationController {
    let viewController = HomeViewController()
    let navController = UINavigationController(
      rootViewController: viewController
    )
    navController.tabBarItem = UITabBarItem(
      title: nil, image: SFSymbols.houseFill, tag: 0
    )
    navController.configureNavigationBarAppearance(
      .systemBackground
    )
    return navController
  }
  
  private func createSearchNavigationController(
  ) -> UINavigationController {
    let viewController = SearchViewController()
    let navController = UINavigationController(
      rootViewController: viewController
    )
    viewController.title = "주제 검색"
    navController.tabBarItem = UITabBarItem(
      title: nil, image: SFSymbols.magnifyingglass, tag: 1
    )
    navController.configureNavigationBarAppearance(.systemBackground)
    return navController
  }
  
  private func createRankingNavigationController(
  ) -> UINavigationController {
    let viewController = RankingViewController()
    let navController = UINavigationController(
      rootViewController: viewController
    )
    viewController.title = "N행시 달인"
    navController.tabBarItem = UITabBarItem(
      title: nil, image: SFSymbols.crownFill, tag: 2
    )
    navController.configureNavigationBarAppearance(
      .systemBackground
    )
    return navController
  }
  
  private func createMyPageNavigationController(
  ) -> UINavigationController {
    let viewController = MyPageViewController()
    let navController = UINavigationController(
      rootViewController: viewController
    )
    viewController.title = "마이페이지"
    navController.tabBarItem = UITabBarItem(
      title: nil, image: SFSymbols.personFill, tag: 3
    )
    navController.configureNavigationBarAppearance(
      .systemBackground
    )
    return navController
  }
}
