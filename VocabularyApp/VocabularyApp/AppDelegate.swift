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
        
        window?.rootViewController = UINavigationController(rootViewController: VocabListViewController())
        
        return true
    }
}

