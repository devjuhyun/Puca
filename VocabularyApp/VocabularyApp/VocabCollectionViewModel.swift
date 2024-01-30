//
//  VocabCollectionViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/10/24.
//

import RealmSwift

class VocabCollectionViewModel {
    
    var isFirstLoad = true
    let currentIndex: Observable<Int>
    private(set) var token: NotificationToken?
    var category: Category?
    private(set) var vocabularies: Observable<[Vocabulary]> = Observable([])
    private let allVocabulariesInDB: Results<Vocabulary> = DBManager.shared.read(Vocabulary.self)
    private let sortOption: SortOption
    private let displayOption: DisplayOption
    let searchText: String?
    
    var navTitle: String {
        return "\(currentIndex.value+1)/\(vocabularies.value.count)"
    }
        
    init(category: Category?, index: Int, sortOption: SortOption, displayOption: DisplayOption, searchText: String?) {
        currentIndex = Observable(index)
        self.category = category
        self.sortOption = sortOption
        self.displayOption = displayOption
        self.searchText = searchText
        token = allVocabulariesInDB.observe { [weak self] changes in
            self?.fetchVocabularies()
        }
    }
    
    func fetchVocabularies() {
        vocabularies.value = category == nil ? Array(allVocabulariesInDB) : Array(category!.vocabularies)
        sortVocabularies()
        filterVocabularies()
    }
    
    private func sortVocabularies() {
        switch sortOption {
        case .newestFirst:
            vocabularies.value.sort { $0.date > $1.date }
        case .oldestFirst:
            vocabularies.value.sort { $0.date < $1.date }
        }
    }
    
    private func filterVocabularies() {
        switch displayOption {
        case .checkedWords:
            vocabularies.value = vocabularies.value.filter { $0.isChecked }
        case .uncheckedWords:
            vocabularies.value = vocabularies.value.filter { !$0.isChecked }
        case .all:
            break
        }
        
        if let searchText = searchText?.lowercased() {
            vocabularies.value = vocabularies.value.filter { $0.word.lowercased().contains(searchText) || $0.meaning.contains(searchText) }
        }
    }
    
    func checkVocabulary(_ vocab: Vocabulary) {
        DBManager.shared.update(vocab) { vocab in
            vocab.isChecked.toggle()
        }
    }
    
    func deleteVocabulary() {
        DBManager.shared.delete(vocabularies.value[currentIndex.value])
    }

}
