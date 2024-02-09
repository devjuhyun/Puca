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
    
    init(identifiers: [String]) {
        self.identifiers = identifiers
    }
    
    func getLanguage(at indexPath: IndexPath) -> String {
        let identifier = identifiers[indexPath.row]
        let language = NSLocale.autoupdatingCurrent.localizedString(forIdentifier: identifier)
        return language ?? "unrecognizable language"
    }
}
