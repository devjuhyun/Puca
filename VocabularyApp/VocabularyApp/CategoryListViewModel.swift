//
//  CategoryListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import RealmSwift

class CategoryListViewModel {
    
    var onCategoriesUpdated: (()->Void)?
    private var token: NotificationToken?

    private(set) var categories: List<Category> {
        didSet {
            onCategoriesUpdated?()
        }
    }
        
    init() {
        categories = DBManager.shared.fetchCategories()
        
        token = categories.observe { changes in
            self.onCategoriesUpdated?()
        }
    }
    
    func deleteCategory(at index: Int) {
        DBManager.shared.delete(categories[index])
    }
    
    func moveCategory(from sourceIndex: Int, to destinationIndex: Int) {
        DBManager.shared.update { [weak self] in
            self?.categories.move(from: sourceIndex, to: destinationIndex)
        }
    }
}
