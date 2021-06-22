//
//  MyPageViewController.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/06/22.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private(set) var myPageView = MyPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        tabBarItem.title = "마이페이지"
        tabBarItem.image = UIImage(systemName: SFSymbols.personFill)
        self.view = myPageView
    }
}
