//
//  LanguageListVIewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/6/24.
//

import Foundation

class LanguageListViewModel {
    
    let isSelectingLanguage: Bool
    var identifiers = LanguageManager.fetchIdentifiers()
    let titleForFooter = "Add new language on Settings. (General > Keyboard > Keyboards > Add New Keyboard)".localized()
    
    init(isSelectingLanguage: Bool) {
        self.isSelectingLanguage = isSelectingLanguage
    }
    
    func getLanguage(at indexPath: IndexPath) -> String {
        let identifier = identifiers[indexPath.row]
        return LanguageManager.getLanguage(for: identifier)
    }
    
    func updateIdentifiers() {
        identifiers = LanguageManager.fetchIdentifiers()
    }
}
