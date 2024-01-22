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
    private(set) var vocabToken: NotificationToken?
    private(set) var categoryToken: NotificationToken?
    var selectedCategory: Observable<Category>
    private(set) var vocabularies: Observable<[Vocabulary]>
    private(set) var sortOption: Observable<SortOption>
    private(set) var displayOption: Observable<DisplayOption>
    private let allVocabulariesInDB: Results<Vocabulary>
    
    var shouldDisplayAllVocabularies: Bool {
        return selectedCategory.value.name == "모든 단어"
    }
    
    // MARK: - Lifecycle
    init(category: Category, sortOption: SortOption, displayOption: DisplayOption) {
        selectedCategory = Observable(category)
        vocabularies = Observable([])
        self.sortOption = Observable(sortOption)
        self.displayOption = Observable(displayOption)
        allVocabulariesInDB = DBManager.shared.read(Vocabulary.self)
        vocabToken = allVocabulariesInDB.observe { [weak self] _ in
            self?.fetchVocabularies()
        }
    }
    
    // MARK: - Work With Vocabulary
    func fetchVocabularies() {
        vocabularies.value = shouldDisplayAllVocabularies ? Array(allVocabulariesInDB) : Array(selectedCategory.value.vocabularies)
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
        shouldDisplayAllVocabularies ? nil : selectedCategory.value
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
}
