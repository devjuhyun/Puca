//
//  CategoryViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import RealmSwift

class CategoryViewModel {
    private(set) var category: Category?
    
    init(category: Category? = nil) {
        self.category = category
    }
    
    func updateCategory(name: String) {
        if let category = category {
            DatabaseManager.shared.update(category) { category in
                category.name = name
            }
        } else {
            let newCategory = Category(name: name)
            DatabaseManager.shared.create(newCategory)
        }
    }
}
