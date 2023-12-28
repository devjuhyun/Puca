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
    
    private init() {}
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error creating new object: \(error)")
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
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
    
    func fetchCategories() -> List<Category> {
        guard let categoryList = realm.object(ofType: CategoryList.self, forPrimaryKey: 0) else { fatalError("Error: no categoryList") }
        return categoryList.categories
    }
}
