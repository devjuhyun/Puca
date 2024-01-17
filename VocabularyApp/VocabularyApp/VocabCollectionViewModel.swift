//
//  VocabCollectionViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/10/24.
//

import Foundation
import RealmSwift

class VocabCollectionViewModel {
    
    var isFirstLoad = true
    let currentIndex: Observable<Int>
    private(set) var token: NotificationToken?
    var selectedCategory: Category?
    private(set) var vocabularies: Observable<[Vocabulary]>
    private let allVocabulariesInDB: Results<Vocabulary>
    
    var navTitle: String {
        return "\(currentIndex.value+1)/\(vocabularies.value.count)"
    }
        
    init(category: Category?, index: Int) {
        currentIndex = Observable(index)
        selectedCategory = category
        vocabularies = Observable([])
        allVocabulariesInDB = DBManager.shared.read(Vocabulary.self)
        token = allVocabulariesInDB.observe { [weak self] changes in
            self?.fetchVocabularies()
        }
    }
    
    func fetchVocabularies() {
        vocabularies.value = selectedCategory == nil ? Array(allVocabulariesInDB) : Array(selectedCategory!.vocabularies)
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
