//
//  DatabaseManager.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import RealmSwift

final class DBManager {
    
    static let shared = DBManager()
    private let realm = try! Realm()
    
    private init() {
        checkCategoryList()
    }
    
    func checkCategoryList() {
        let categoryList = realm.object(ofType: CategoryList.self, forPrimaryKey: 0)
        if categoryList == nil {
            try! realm.write {
                let categoryList = CategoryList()
                categoryList.categories.append(Category(name: "모든 단어"))
                realm.add(categoryList)
            }
        }
    }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func update(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print("Error updating object: \(error)")
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting an object: \(error)")
        }
    }
    
    func fetchCategoryList() -> CategoryList {
        guard let categoryList = realm.object(ofType: CategoryList.self, forPrimaryKey: 0) else { fatalError("Error: no categoryList") }
        return categoryList
    }
}
