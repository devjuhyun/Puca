//
//  Category.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/23.
//

import Foundation
import RealmSwift

enum SortOption: String, PersistableEnum {
    case newestFirst
    case oldestFirst
}

enum DisplayOption: String, PersistableEnum {
    case all
    case checkedWords
    case uncheckedWords
}

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var vocabularies: List<Vocabulary>
    @Persisted var sortOption: SortOption = .newestFirst
    @Persisted var displayOption: DisplayOption = .all
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
