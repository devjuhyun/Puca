//
//  MainViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

class MainViewController: UITabBarController {
    
    private let vocabListVC = VocabListViewController()
    private let dummyVC1 = UIViewController()
    private let dummyVC2 = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
        setupNavBar()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

extension MainViewController {
    private func setup() {
        delegate = self // tab bar controller delegate
        vocabListVC.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(categoryClicked), name: .category, object: nil)
        self.popoverPresentationController?.backgroundColor = self.view.backgroundColor
    }
    
    private func setupViews() {
        vocabListVC.setTabBarImage(imageName: "note.text",title: "단어장")
        dummyVC1.setTabBarImage(imageName: "plus", title: "새 단어")
        dummyVC2.setTabBarImage(imageName: "magnifyingglass", title: "검색")
        
        let tabBarList = [vocabListVC, dummyVC1, dummyVC2]

        viewControllers = tabBarList
    }
    
    private func setupNavBar() {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        button.tintColor = .label
        navigationItem.backBarButtonItem = button
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
            let nc = UINavigationController(rootViewController: AddVocabViewController())
            nc.modalPresentationStyle = .fullScreen
            nc.navigationBar.topItem?.title = "단어 추가"
            present(nc, animated: true, completion: nil)
            return false
        }

        return true
    }
}

extension MainViewController: VocabListViewControllerDelegate {
    func didSelectVocab() {
        navigationController?.pushViewController(VocabViewController(), animated: true)
    }
    
}

extension MainViewController {
    @objc func categoryClicked() {
        let vc = CategoryListViewController()
        vc.navigationItem.title = "단어장 선택"
        navigationController?.pushViewController(vc, animated: true)
    }
}
