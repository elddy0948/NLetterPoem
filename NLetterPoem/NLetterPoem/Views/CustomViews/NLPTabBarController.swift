//
//  NLPTabBarController.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/06/22.
//

import UIKit

class NLPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        viewControllers = [createHomeNavigaionController(),
                           createRankingNavigationController(),
                           createMyPageNavigationController()]
    }
    
    private func createHomeNavigaionController() -> UINavigationController {
        let viewController = HomeViewController()
        viewController.title = "Home"
        viewController.tabBarItem = UITabBarItem(title: "홈", image: SFSymbols.houseFill, tag: 0)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createRankingNavigationController() -> UINavigationController {
        let viewController = RankingViewController()
        viewController.title = "랭킹"
        viewController.tabBarItem = UITabBarItem(title: "랭킹", image: SFSymbols.crownFill, tag: 1)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createMyPageNavigationController() -> UINavigationController {
        let viewController = MyPageViewController()
        viewController.title = "마이페이지"
        viewController.tabBarItem = UITabBarItem(title: "마이페이지", image: SFSymbols.personFill, tag: 2)
        return UINavigationController(rootViewController: viewController)
    }
}
