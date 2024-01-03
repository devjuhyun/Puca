//
//  VocabViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import UIKit

class VocabViewModel {
    
    let selectedCategory: Observable<Category?>
    
    init(selectedCategory: Category?) {
        self.selectedCategory = Observable(selectedCategory)
    }
    
    private func updateVocab(vocab: String, meaning: String, example: String) {
        DBManager.shared.update {
            let vocab = Vocabulary(word: vocab, meaning: meaning, example: example)
            selectedCategory.value?.vocabularies.append(vocab)
        }
    }
}
