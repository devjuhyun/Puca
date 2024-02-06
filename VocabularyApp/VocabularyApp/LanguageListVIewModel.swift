//
//  LanguageListVIewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/6/24.
//

import Foundation

class LanguageListVIewModel {
    var languages = [String]()
    var filteredLanguages = [String]()
    var inSearchMode: Bool = false
    
    var languagesToDisplay: [String] {
        return inSearchMode ? filteredLanguages : languages
    }
    
    init() {
        fetchLanguages()
    }
    
    private func fetchLanguages() {
        let identifiers = NSLocale.availableLocaleIdentifiers.sorted()
        let locale = NSLocale.autoupdatingCurrent
        languages = identifiers.map { locale.localizedString(forIdentifier: $0) ?? "error" }
    }

    public func setInSearchMode(isSearching: Bool, searchText: String) {
        inSearchMode = isSearching && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        if let searchText = searchBarText?.lowercased() {
            filteredLanguages = languages.filter { $0.lowercased().contains(searchText)
            }
        }
    }
    
}
