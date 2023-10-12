//
//  Vocabulary.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/21.
//

import Foundation
import RealmSwift

class Vocabulary: Object {
    init(vocab: String, meaning: String, example: String? = nil, isChecked: Bool, date: Date? = nil) {
        self.vocab = vocab
        self.meaning = meaning
        self.example = example
        self.isChecked = isChecked
        self.date = date
    }
    
    @Persisted var vocab: String = ""
    @Persisted var meaning: String = ""
    @Persisted var example: String?
    @Persisted var isChecked: Bool = false
    @Persisted var date: Date?
}
