//
//  AppDelegate.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: VocabListViewController())
        
        let realm = try! Realm()
        let categoryList = realm.object(ofType: CategoryList.self, forPrimaryKey: 0)
        if categoryList == nil {
            try! realm.write {
                realm.add(CategoryList())
            }
        }
        
        return true
    }
}

