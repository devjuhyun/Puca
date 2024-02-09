//
//  LanguageManager.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/9/24.
//

import UIKit

struct LanguageManager {
    static func fetchIdentifiers() -> [String] {
        return UITextInputMode.activeInputModes.map { $0.primaryLanguage }.compactMap{ $0 }.filter { $0 != "emoji" }
    }
    
    static func getLanguage(for identifier: String) -> String {
        let language = NSLocale.autoupdatingCurrent.localizedString(forIdentifier: identifier)
        return language ?? "unrecognizable language"
    }
}
