//
//  CategoryList.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/27/23.
//

import Foundation
import RealmSwift

class CategoryList: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var categories: List<Category>
}
