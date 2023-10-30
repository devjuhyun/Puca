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
    @Persisted var date: Date = Date()
    
    @Persisted var vocabularies: List<Vocabulary>
}
