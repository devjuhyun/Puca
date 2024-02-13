//
//  CategoryViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import RealmSwift

class CategoryViewModel {
    private(set) var category: Observable<Category?> = Observable(nil)
    private(set) var languageIdentifier: Observable<String?> = Observable(nil)
    private(set) var nativeLanguageIdentifier: Observable<String?> = Observable(nil)
    
    init(category: Category? = nil) {
        self.category.value = category
        languageIdentifier.value = category?.language
        nativeLanguageIdentifier.value = category?.nativeLanguage
    }
    
    func updateCategory(name: String) {
        let language = languageIdentifier.value
        let nativeLanguage = nativeLanguageIdentifier.value
        
        if let category = category.value { // update a category
            DBManager.shared.update(category) { category in
                category.name = name
                category.language = language
                category.nativeLanguage = nativeLanguage
            }
        } else { // add new category
            let categoryList = DBManager.shared.fetchCategoryList()
            DBManager.shared.update(categoryList) { categoryList in
                let newCategory = Category(name: name, language: language, nativeLanguage: nativeLanguage)
                categoryList.categories.append(newCategory)
            }
        }
    }
}
