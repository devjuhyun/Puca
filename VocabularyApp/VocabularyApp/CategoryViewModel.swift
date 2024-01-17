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
        if let category = category { // update category
            DBManager.shared.update(category) { category in
                category.name = name
            }
        } else { // add category
            let categoryList = DBManager.shared.fetchCategoryList()
            DBManager.shared.update(categoryList) { categoryList in
                let newCategory = Category(name: name)
                categoryList.categories.append(newCategory)
            }
        }
    }
}
