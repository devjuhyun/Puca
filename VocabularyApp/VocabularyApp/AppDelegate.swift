//
//  AppDelegate.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

let appColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let NC = UINavigationController(rootViewController: VocabListViewController())
        NC.navigationBar.prefersLargeTitles = true
        NC.navigationBar.topItem?.title = "Category"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .secondarySystemGroupedBackground
        appearance.shadowColor = .clear
        NC.navigationBar.standardAppearance = appearance
        NC.navigationBar.scrollEdgeAppearance = appearance
        
        let nc = UINavigationController(rootViewController: AddVocabViewController())
        nc.navigationBar.topItem?.title = ""
        nc.navigationBar.standardAppearance = appearance
        nc.navigationBar.scrollEdgeAppearance = appearance
        
        window?.rootViewController = UINavigationController(rootViewController: VocabViewController(vocab: "puma", example: "Puma is the best cat in the world.",meaning: "푸마", isChecked: true))
        
        return true
    }
}

