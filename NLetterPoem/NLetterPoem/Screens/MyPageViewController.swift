//
//  MyPageViewController.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/06/22.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private(set) var myPageView: MyPageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureMyPageView()
    }
    
    private func configure() {
        tabBarItem.title = "마이페이지"
        tabBarItem.image = UIImage(systemName: SFSymbols.personFill)
        view.backgroundColor = .systemBackground
    }
    
    private func configureMyPageView() {
        myPageView = MyPageView()
        view.addSubview(myPageView)
        
        NSLayoutConstraint.activate([
            myPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myPageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
