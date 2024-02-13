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
                
        let recentCategoryIndex = UserDefaults.standard.object(forKey: "recentCategoryIndex") as? Int
        let category = DBManager.shared.fetchCategoryList().categories[recentCategoryIndex ?? 0]
        let sortOption = SortOption(rawValue: UserDefaults.standard.object(forKey: "sortOption") as? String ?? "newestFirst") ?? .newestFirst
        let displayOption = DisplayOption(rawValue: UserDefaults.standard.object(forKey: "displayOption") as? String ?? "all") ?? .all
        let vm = VocabListViewModel(category: category, sortOption: sortOption, displayOption: displayOption)
        window?.rootViewController = UINavigationController(rootViewController: VocabListViewController(viewModel: vm))
                
        return true
    }
}

