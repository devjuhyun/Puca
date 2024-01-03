//
//  VocabListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import RealmSwift

class VocabListViewModel {
    
    private var token: NotificationToken?
    var selectedCategory: Observable<Category>
    private(set) var vocabs: Observable<[Vocabulary]>
    
    var isAllCategory: Bool {
        return DBManager.shared.isAllCategory(category: selectedCategory.value)
    }
    
    init(category: Category) {
        selectedCategory = Observable(category)
        vocabs = Observable([])
        updateToken()
    }
    
    func updateToken() {
        token = selectedCategory.value.vocabularies.observe { [weak self] changes in
            self?.fetchVocabularies()
        }
    }
    
    private func fetchVocabularies() {
        vocabs.value = Array(selectedCategory.value.vocabularies)
    }
}







// TODO: - 모든 카테고리 어떻게 처리할건지 생각하기
// 모든 카테고리를 실제로 Category object로 생성하는 방법과
// CategoryListViewController TableView에 행만 삽입해서 하는 것
// TODO: - 단어 추가하는 기능 만들기

