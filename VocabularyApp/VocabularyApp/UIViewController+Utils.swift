//
//  UIViewController+Utils.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

extension UIViewController {
//    func setStatusBar() {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground() // to hide Navigation Bar Line also0
//        navBarAppearance.backgroundColor = appColor
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//    }
    
    func setTabBarImage(imageName: String, pointSize: CGFloat) {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .heavy) // sf symbol large size
        let image = UIImage(systemName: imageName, withConfiguration: configuration)?.withBaselineOffset(fromBottom: 18)
        tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
    }
}
