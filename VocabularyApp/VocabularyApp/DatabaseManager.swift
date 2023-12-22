//
//  DatabaseManager.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import RealmSwift

protocol DataBase {
    func create<T: Object>(_ object: T)
}

class DatabaseManager: DataBase {
    
    static let shared = DatabaseManager()
    private let realm = try! Realm()
    
    private init() {}
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    // TODO: - Add CRUD Methods
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error creating new object: \(error)")
        }
    }
    
    
}
