//
//  AppDelegate.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

// TODO: - write test code
// TODO: - test all devices

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
                
        let vm = getVocabListViewModel()
        window?.rootViewController = UINavigationController(rootViewController: VocabListViewController(viewModel: vm))
                
        return true
    }
    
    private func getVocabListViewModel() -> VocabListViewModel {
        let categories = DBManager.shared.fetchCategoryList().categories
        let recentCategoryIndex = UserDefaults.standard.object(forKey: "recentCategoryIndex") as? Int ?? 0
        let index = categories[safe: recentCategoryIndex] == nil ? 0 : recentCategoryIndex
        let sortOption = SortOption(rawValue: UserDefaults.standard.object(forKey: "sortOption") as? String ?? "newestFirst") ?? .newestFirst
        let displayOption = DisplayOption(rawValue: UserDefaults.standard.object(forKey: "displayOption") as? String ?? "all") ?? .all
        
        return VocabListViewModel(category: categories[index], sortOption: sortOption, displayOption: displayOption, shouldDisplayAllVocabulariesInDB: index == 0)
    }
}

