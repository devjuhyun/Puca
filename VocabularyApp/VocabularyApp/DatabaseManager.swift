//
//  DatabaseManager.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    private init() {}
    
}
