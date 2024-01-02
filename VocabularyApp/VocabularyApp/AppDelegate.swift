//
//  AppDelegate.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let category = DBManager.shared.fetchCategoryList().categories.first!
        let vm = VocabListViewModel(category: category)
        window?.rootViewController = UINavigationController(rootViewController: VocabListViewController(viewModel: vm))
        
        return true
    }
}

