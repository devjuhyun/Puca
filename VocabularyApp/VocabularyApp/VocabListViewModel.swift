//
//  VocabListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import RealmSwift

enum SortOption: String {
    case newestFirst
    case oldestFirst
}

enum DisplayOption: String {
    case all
    case checkedWords
    case uncheckedWords
}

class VocabListViewModel {
    // MARK: - Properties
    var inSearchMode: Bool = false
    private(set) var token: NotificationToken?
    var selectedCategory: Observable<Category>
    private let allVocabulariesInDB = DBManager.shared.read(Vocabulary.self)
    private(set) var vocabularies: Observable<[Vocabulary]> = Observable([])
    private(set) var filteredVocabularies: Observable<[Vocabulary]> = Observable([])
    private(set) var sortOption: Observable<SortOption>
    private(set) var displayOption: Observable<DisplayOption>
    
    var vocabulariesToDisplay: [Vocabulary] {
        return inSearchMode ? filteredVocabularies.value : vocabularies.value
    }
    
    var shouldDisplayAllVocabulariesInDB: Bool {
        return selectedCategory.value.name == "모든 단어"
    }
    
    // MARK: - Lifecycle
    init(category: Category, sortOption: SortOption, displayOption: DisplayOption) {
        self.selectedCategory = Observable(category)
        self.sortOption = Observable(sortOption)
        self.displayOption = Observable(displayOption)
        token = allVocabulariesInDB.observe { [weak self] _ in
            self?.fetchVocabularies()
        }
    }
    
    // MARK: - Work With Vocabulary
    func fetchVocabularies() {
        vocabularies.value = shouldDisplayAllVocabulariesInDB ? Array(allVocabulariesInDB) : Array(selectedCategory.value.vocabularies)
        sortVocabularies()
        filterVocabularies()
    }
    
    private func sortVocabularies() {
        switch sortOption.value {
        case .newestFirst:
            vocabularies.value.sort { $0.date > $1.date }
        case .oldestFirst:
            vocabularies.value.sort { $0.date < $1.date }
        }
    }
    
    // TODO: - 카테고리 바뀔때만 호출되게 하기
    private func filterVocabularies() {
        switch displayOption.value {
        case .checkedWords:
            vocabularies.value = vocabularies.value.filter { $0.isChecked }
        case .uncheckedWords:
            vocabularies.value = vocabularies.value.filter { !$0.isChecked }
        case .all:
            break
        }
    }
    
    func checkVocabulary(_ vocab: Vocabulary) {
        DBManager.shared.update(vocab) { vocab in
            vocab.isChecked.toggle()
        }
    }
    
    // MARK: - Work With Category
    func passCategory() -> Category? {
        shouldDisplayAllVocabulariesInDB ? nil : selectedCategory.value
    }
    
    // MARK: - Work With UserDefaults
    func updateSortOption(_ sortOption: SortOption) {
        UserDefaults.standard.set(sortOption.rawValue, forKey: "sortOption")
        self.sortOption.value = sortOption
    }
    
    func updateDisplayOption(_ displayOption: DisplayOption) {
        UserDefaults.standard.set(displayOption.rawValue, forKey: "displayOption")
        self.displayOption.value = displayOption
    }
    
    // MARK: - Search Functions
    public func setInSearchMode(isSearching: Bool, searchText: String) {
        inSearchMode = isSearching && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        if let searchText = searchBarText?.lowercased() {
            filteredVocabularies.value = vocabularies.value.filter { $0.word.lowercased().contains(searchText) || $0.meaning.contains(searchText) }
        }
    }
}
