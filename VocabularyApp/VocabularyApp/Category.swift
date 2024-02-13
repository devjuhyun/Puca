//
//  Category.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var vocabularies: List<Vocabulary>
    @Persisted var language: String?
    @Persisted var nativeLanguage: String?
    
    convenience init(name: String, language: String? = nil, nativeLanguage: String? = nil) {
        self.init()
        self.name = name
        self.language = language
        self.nativeLanguage = nativeLanguage
    }
}
