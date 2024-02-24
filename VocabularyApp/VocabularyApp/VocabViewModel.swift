//
//  VocabViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

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
    
    private func saveVocabulary(word: String, meaning: String, example: String) {
        guard let selectedCategory = selectedCategory.value else { return }
        let newVocab = Vocabulary(word: word, meaning: meaning, example: example)
        
        if let selectedVocab = selectedVocab {
            newVocab.isChecked = selectedVocab.isChecked
            newVocab.date = selectedVocab.date
            DBManager.shared.delete(selectedVocab)
        }
        
        DBManager.shared.update(selectedCategory) { selectedCategory in
            selectedCategory.vocabularies.append(newVocab)
        }
    }
    
    func checkBlankSpace(word: String, meaning: String, example: String) -> (BlankSpace?, String, Bool) {
        if selectedCategory.value == nil {
            return (.category, "Select a category.".localized(), false)
        } else if word.isEmpty {
            return (.vocab, "Please enter a word.".localized(), false)
        } else if meaning.isEmpty {
            return (.meaning, "Please enter the meaning of the word.".localized(), false)
        } else {
            saveVocabulary(word: word, meaning: meaning, example: example)
            return (nil, "You have successfully added a new word.".localized(), true)
        }
    }
}
