//
//  MainViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTabBar()
    }
}

extension MainViewController {
    private func setupViews() {
        let vocabListVC = VocabListViewController()
        let dummyVC1 = UIViewController()
        let dummyVC2 = UIViewController()
    
        vocabListVC.setTabBarImage(imageName: "house", pointSize: 17)
        dummyVC1.setTabBarImage(imageName: "plus", pointSize: 22)
        dummyVC2.setTabBarImage(imageName: "magnifyingglass", pointSize: 19)
        
        let tabBarList = [vocabListVC, dummyVC1, dummyVC2]

        viewControllers = tabBarList
    }
    
    private func setupTabBar() {
        tabBar.tintColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        tabBar.backgroundColor = .secondarySystemGroupedBackground
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        tabBar.addSubview(separator)
        separator.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.widthAnchor.constraint(equalTo: tabBar.widthAnchor).isActive = true
    }
}
