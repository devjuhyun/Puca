//
//  VocabListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import RealmSwift

class VocabListViewModel {
    
    private var token: NotificationToken?
    var selectedCategory: Observable<Category>
    private(set) var vocabs: Observable<[Vocabulary]>
    
    init(category: Category) {
        selectedCategory = Observable(category)
        vocabs = Observable([])
        
        token = selectedCategory.value.vocabularies.observe { [weak self] changes in
            self?.fetchVocabularies()
        }
    }
    
    func fetchVocabularies() {
        vocabs.value = Array(selectedCategory.value.vocabularies)
    }
}
