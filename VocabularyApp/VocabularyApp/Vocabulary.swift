//
//  Vocabulary.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/21.
//

import Foundation
import RealmSwift

class Vocabulary: Object {
    @Persisted var vocab: String = ""
    @Persisted var meaning: String = ""
    @Persisted var example: String?
    @Persisted var isChecked: Bool = false
    @Persisted var date: Date?
}
