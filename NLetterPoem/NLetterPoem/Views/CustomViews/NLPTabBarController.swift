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
        viewControllers = [createHomeNavigaionController(), createMyPageNavigationController()]
    }
    
    private func createHomeNavigaionController() -> UINavigationController {
        let viewController = ViewController()
        viewController.title = "Home"
        viewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: SFSymbols.houseFill), tag: 0)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createMyPageNavigationController() -> UINavigationController {
        let viewController = MyPageViewController()
        viewController.title = "마이페이지"
        viewController.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: SFSymbols.personFill), tag: 1)
        return UINavigationController(rootViewController: viewController)
    }
}
