//
//  CategoryListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import Foundation
import RealmSwift

class CategoryListViewModel {
    
    var shouldDisplayAll = false
    private(set) var token: NotificationToken?
    private(set) var categoryList: CategoryList
    private(set) var categories: Observable<[Category]>
        
    init() {
        categoryList = DBManager.shared.fetchCategoryList()
        categories = Observable([])
        
        token = categoryList.categories.observe { [weak self] changes in
            self?.fetchCategories()
        }
    }
    
    func fetchCategories() {
        let categoriesInDB = Array(categoryList.categories)
        categories.value = shouldDisplayAll ? categoriesInDB : Array(categoriesInDB[1...])
    }
    
    func deleteCategory(at index: Int) {
        DBManager.shared.delete(categories.value[index])
    }
    
    func moveCategory(from sourceIndex: Int, to destinationIndex: Int) {
        let n = shouldDisplayAll ? 0 : 1
        
        DBManager.shared.update { [weak self] in
            self?.categoryList.categories.move(from: sourceIndex+n, to: destinationIndex+n)
        }
    }
    
    func canEditRowAt(index: Int) -> Bool {
        return shouldDisplayAll ? index != 0 : true
    }
    
    func getTargetIndexPath(sourceIndexPath: IndexPath, proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return shouldDisplayAll && proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}
