//
//  CategoryListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import RealmSwift

class CategoryListViewModel {
    
    var onCategoriesUpdated: (()->Void)?
    var token: NotificationToken?
    
    private(set) var categories: Results<Category> {
        didSet {
            onCategoriesUpdated?()
        }
    }
        
    init() {
        categories = DatabaseManager.shared.read(Category.self)
        token = categories.observe { changes in
            self.onCategoriesUpdated?()
        }
    }
}
