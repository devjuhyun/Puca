//
//  Vocabulary.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/21.
//

import Foundation
import RealmSwift

class Vocabulary: Object {
    @Persisted var word: String = ""
    @Persisted var meaning: String = ""
    @Persisted var example: String = ""
    @Persisted var isChecked: Bool = false
    @Persisted var date: Date = Date()
    
    @Persisted(originProperty: "vocabularies") var parentCategory: LinkingObjects<Category>
    
    convenience init(word: String, meaning: String, example: String) {
        self.init()
        self.word = word
        self.meaning = meaning
        self.example = example
    }
}
