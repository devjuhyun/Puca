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
        if category != nil { // edit category
            DBManager.shared.update { [weak self] in
                self?.category?.name = name
            }
        } else { // add category
            let categoryList = DBManager.shared.fetchCategoryList()
            DBManager.shared.update {
                let newCategory = Category(name: name)
                categoryList.categories.append(newCategory)
            }
        }
    }
}
