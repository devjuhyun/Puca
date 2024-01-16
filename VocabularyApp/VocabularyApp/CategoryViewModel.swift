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
        DBManager.shared.update { [weak self] in
            if self?.category != nil { // edit category
                self?.category?.name = name
            } else { // add category
                let categoryList = DBManager.shared.fetchCategoryList()
                    let newCategory = Category(name: name)
                    categoryList.categories.append(newCategory)
            }
        }
    }
}
