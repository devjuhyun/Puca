//
//  VocabViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import UIKit

enum BlankSpace {
    case category
    case vocab
    case meaning
}

class VocabViewModel {
    
    let selectedCategory: Observable<Category?>
    let selectedVocab: Vocabulary?
    
    init(selectedCategory: Category?, selectedVocab: Vocabulary? = nil) {
        self.selectedCategory = Observable(selectedCategory)
        self.selectedVocab = selectedVocab
    }
    
    private func updateVocab(vocab: String, meaning: String, example: String) {
        guard let selectedCategory = selectedCategory.value else { return }
        let newVocab = Vocabulary(word: vocab, meaning: meaning, example: example)
        
        if let selectedVocab = selectedVocab {
            newVocab.isChecked = selectedVocab.isChecked
            newVocab.date = selectedVocab.date
            DBManager.shared.delete(selectedVocab)
        }
        
        DBManager.shared.update(selectedCategory) { selectedCategory in
            selectedCategory.vocabularies.append(newVocab)
        }
    }
    
    func checkBlankSpace(vocab: String, meaning: String, example: String, handler: (BlankSpace?, UIView) -> Void) {
        if selectedCategory.value == nil {
            handler(.category, ToastView(message: "단어장을 선택하세요."))
        } else if vocab.isEmpty {
            handler(.vocab, ToastView(message: "단어를 입력하세요."))
        } else if meaning.isEmpty {
            handler(.meaning, ToastView(message: "의미를 입력하세요."))
        } else {
            updateVocab(vocab: vocab, meaning: meaning, example: example)
            handler(nil, ToastView(message: "단어 저장 성공", color: .systemGreen, imageName: "checkmark.circle"))
        }
    }
}
