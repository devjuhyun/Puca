//
//  LanguageListVIewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/6/24.
//

import Foundation

class LanguageListViewModel {
    
    var identifiers: [String]
    let titleForFooter = "Add new language on Settings. (General > Keyboard > Keyboards > Add New Keyboard)".localized()
    
    init() {
        self.identifiers = LanguageManager.fetchIdentifiers()
    }
    
    func getLanguage(at indexPath: IndexPath) -> String {
        let identifier = identifiers[indexPath.row]
        return LanguageManager.getLanguage(for: identifier)
    }
    
    func updateIdentifiers() {
        identifiers = LanguageManager.fetchIdentifiers()
    }
}
