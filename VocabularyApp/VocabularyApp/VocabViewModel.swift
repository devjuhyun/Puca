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
        
        if let selectedVocab = selectedVocab {
            DBManager.shared.move(vocabularies: [selectedVocab], to: selectedCategory)
        } else {
            DBManager.shared.update(selectedCategory) { selectedCategory in
                let newVocab = Vocabulary(word: vocab, meaning: meaning, example: example)
                selectedCategory.vocabularies.append(newVocab)
            }
        }
    }
    
    func checkBlankSpace(vocab: String, meaning: String, example: String, handler: (BlankSpace?, String, Bool) -> Void) {
        if selectedCategory.value == nil {
            handler(.category, "단어장을 선택하세요.", false)
        } else if vocab.isEmpty {
            handler(.vocab, "단어를 입력하세요.", false)
        } else if meaning.isEmpty {
            handler(.meaning, "의미를 입력하세요.", false)
        } else {
            updateVocab(vocab: vocab, meaning: meaning, example: example)
            handler(nil, "단어 저장 성공", true)
        }
    }
}
