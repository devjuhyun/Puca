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
    
    func checkBlankSpace(vocab: String, meaning: String, example: String, handler: (BlankSpace?, String, Bool) -> Void) {
        if selectedCategory.value == nil {
            handler(.category, "Select a category.", false)
        } else if vocab.isEmpty {
            handler(.vocab, "Please enter a word.", false)
        } else if meaning.isEmpty {
            handler(.meaning, "Please enter the meaning of the word.", false)
        } else {
            updateVocab(vocab: vocab, meaning: meaning, example: example)
            handler(nil, "You have successfully added a new word.", true)
        }
    }
}
