//
//  CategoryListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import Foundation
import RealmSwift

class CategoryListViewModel {
    
    var shouldDisplayAllCategories = false
    private var token: NotificationToken?
    private(set) var categoryList: CategoryList
    private(set) var categories: Observable<[Category]>
        
    init() {
        categoryList = DBManager.shared.fetchCategoryList()
        categories = Observable([])
        
        token = categoryList.categories.observe { changes in
            let categories = Array(self.categoryList.categories)
            self.categories.value = self.shouldDisplayAllCategories ? categories : Array(categories[1...])
        }
    }
    
    func deleteCategory(at index: Int) {
        DBManager.shared.delete(categories.value[index])
    }
    
    func moveCategory(from sourceIndex: Int, to destinationIndex: Int) {
        let n = shouldDisplayAllCategories ? 0 : 1
        
        DBManager.shared.update { [weak self] in
            self?.categoryList.categories.move(from: sourceIndex+n, to: destinationIndex+n)
        }
    }
    
    func canEditRowAt(index: Int) -> Bool {
        return shouldDisplayAllCategories ? index != 0 : true
    }
    
    func getTargetIndexPath(sourceIndexPath: IndexPath, proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return shouldDisplayAllCategories && proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}
