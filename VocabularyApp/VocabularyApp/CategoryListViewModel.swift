//
//  CategoryListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/22/23.
//

import Foundation
import RealmSwift

class CategoryListViewModel {
    
    let shouldDisplayAll: Bool
    private(set) var token: NotificationToken?
    private let categoryList = DBManager.shared.fetchCategoryList()
    let categories: Observable<[Category]> = Observable([])
    let total = DBManager.shared.read(Vocabulary.self).count
        
    init(shouldDisplayAll: Bool) {
        self.shouldDisplayAll = shouldDisplayAll
        token = categoryList.categories.observe { [weak self] changes in
            self?.fetchCategories()
        }
    }
    
    func fetchCategories() {
        let categoriesInDB = Array(categoryList.categories)
        let categoriesWithOutAll = (1..<categoriesInDB.count).map { categoriesInDB[$0] }
        categories.value = shouldDisplayAll ? categoriesInDB : categoriesWithOutAll
    }
    
    func deleteCategory(at index: Int) {
        DBManager.shared.delete(categories.value[index])
    }
    
    func moveCategory(from sourceIndex: Int, to destinationIndex: Int) {
        let n = shouldDisplayAll ? 0 : 1
        
        DBManager.shared.update(categoryList) { categoryList in
            categoryList.categories.move(from: sourceIndex+n, to: destinationIndex+n)
        }
    }
    
    func canEditRowAt(index: Int) -> Bool {
        return shouldDisplayAll ? index != 0 : true
    }
    
    func getTargetIndexPath(sourceIndexPath: IndexPath, proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return shouldDisplayAll && proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}
