//
//  Extensions.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 11/11/23.
//

import UIKit

extension UIColor {
    static let appColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
}

extension UINavigationItem {
    func setBackBarButtonItem() {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        button.tintColor = .label
        backBarButtonItem = button
    }
}

extension UINavigationController {
    var previousViewController: UIViewController? {
        viewControllers.last { $0 != topViewController }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
