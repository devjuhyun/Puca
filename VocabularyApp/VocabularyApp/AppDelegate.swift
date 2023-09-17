//
//  AppDelegate.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

let appColor = UIColor(red: 15/255, green: 100/255, blue: 71/255, alpha: 1.0) /* #0f6447 */

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
        NC.navigationBar.standardAppearance = appearance
        NC.navigationBar.scrollEdgeAppearance = appearance
        
        window?.rootViewController = NC

        return true
    }
}

