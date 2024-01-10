//
//  VocabListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import RealmSwift

class VocabListViewModel {
    
    var shouldDisplayAllVocabularies = true
    private var token: NotificationToken?
    var selectedCategory: Observable<Category>
    private(set) var vocabularies: Observable<[Vocabulary]>
    private let allVocabulariesInDB: Results<Vocabulary>
        
    init(category: Category) {
        selectedCategory = Observable(category)
        vocabularies = Observable([])
        allVocabulariesInDB = DBManager.shared.read(Vocabulary.self)
        token = allVocabulariesInDB.observe { [weak self] changes in
            self?.fetchVocabularies()
        }
    }
    
    func fetchVocabularies() {
        vocabularies.value = shouldDisplayAllVocabularies ? Array(allVocabulariesInDB) : Array(selectedCategory.value.vocabularies)
    }
    
    func passCategory() -> Category? {
        shouldDisplayAllVocabularies ? nil : selectedCategory.value
    }
    
    func checkVocabulary(_ vocab: Vocabulary) {
        DBManager.shared.update {
            vocab.isChecked.toggle()
        }
    }
}
