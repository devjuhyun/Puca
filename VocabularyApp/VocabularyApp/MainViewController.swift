//
//  MainViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

class MainViewController: UITabBarController {
    
    let vocabListVC = VocabListViewController()
    let dummyVC1 = UIViewController()
    let dummyVC2 = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupViews()
        setupTabBar()
    }
}

extension MainViewController {
    private func setupViews() {
        vocabListVC.setTabBarImage(imageName: "note.text",title: "단어장")
        dummyVC1.setTabBarImage(imageName: "plus", title: "새 단어")
        dummyVC2.setTabBarImage(imageName: "magnifyingglass", title: "검색")
        
        let tabBarList = [vocabListVC, dummyVC1, dummyVC2]

        viewControllers = tabBarList
    }
    
    private func setupTabBar() {
        tabBar.tintColor = appColor
        tabBar.backgroundColor = .secondarySystemGroupedBackground
        tabBar.frame.size.height = 20
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        tabBar.addSubview(separator)
        separator.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.widthAnchor.constraint(equalTo: tabBar.widthAnchor).isActive = true
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            let nc1 = UINavigationController(rootViewController: AddVocabViewController())
            nc1.modalPresentationStyle = .popover
            present(nc1, animated: true, completion: nil)
            return false
        }

        return true
    }
}
