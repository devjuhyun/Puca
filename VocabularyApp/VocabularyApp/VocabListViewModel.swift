//
//  VocabListViewModel.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/2/24.
//

import Foundation
import RealmSwift
import UIKit

class VocabListViewModel {
    
    var onCategoryUpdated: (()->Void)?
    private(set) var vocabToken: NotificationToken?
    private(set) var categoryToken: NotificationToken?
    var selectedCategory: Observable<Category>
    private(set) var vocabularies: Observable<[Vocabulary]>
    private let allVocabulariesInDB: Results<Vocabulary>
    
    var shouldDisplayAllVocabularies: Bool {
        return selectedCategory.value.name == "모든 단어"
    }
    
    init(category: Category) {
        selectedCategory = Observable(category)
        vocabularies = Observable([])
        allVocabulariesInDB = DBManager.shared.read(Vocabulary.self)
        updateTokens()
    }
    
    func updateTokens() { // 초기화했을때, 카테고리 변경됐을 때
        updateCategoryToken()
        updateVocabToken()
    }
    
    private func updateCategoryToken() { // 카테고리의 속성이 변경될 때
        categoryToken = selectedCategory.value.observe { [weak self] changes in
            self?.fetchVocabularies()
            self?.onCategoryUpdated?()
        }
    }
    
    private func updateVocabToken() { // 단어 목록이 변경되거나 속성이 변경될 때
        if shouldDisplayAllVocabularies {
            vocabToken = allVocabulariesInDB.observe { [weak self] _ in
                self?.fetchVocabularies()
            }
        } else {
            vocabToken = selectedCategory.value.vocabularies.observe { [weak self] _ in
                self?.fetchVocabularies()
            }
        }
    }
    
    func fetchVocabularies() {
        vocabularies.value = shouldDisplayAllVocabularies ? Array(allVocabulariesInDB) : Array(selectedCategory.value.vocabularies)
        sortVocabularies()
        filterVocabularies()
    }
    
    private func sortVocabularies() {
        switch selectedCategory.value.sortOption {
        case .newestFirst:
            vocabularies.value.sort { $0.date > $1.date }
        case .oldestFirst:
            vocabularies.value.sort { $0.date < $1.date }
        }
    }
    
    // TODO: - 카테고리 바뀔때만 호출되게 하기
    private func filterVocabularies() {
        switch selectedCategory.value.displayOption {
        case .checkedWords:
            vocabularies.value = vocabularies.value.filter { $0.isChecked }
        case .uncheckedWords:
            vocabularies.value = vocabularies.value.filter { !$0.isChecked }
        case .all:
            break
        }
    }
    
    func passCategory() -> Category? {
        shouldDisplayAllVocabularies ? nil : selectedCategory.value
    }
    
    func checkVocabulary(_ vocab: Vocabulary) {
        DBManager.shared.update(vocab) { vocab in
            vocab.isChecked.toggle()
        }
    }
    
    func updateCategory(sortOption: SortOption? = nil, displayOption: DisplayOption? = nil) {
        DBManager.shared.update(selectedCategory.value) { category in
            category.sortOption = sortOption ?? category.sortOption
            category.displayOption = displayOption ?? category.displayOption
        }
    }
}


// 1. 이벤트로 인해 카테고리가 변경
// 2. 카테고리 버튼 타이틀 변경, 카테고리 토큰 변경, vocabularies 변경

// 1. 이벤트로 인해 카테고리의 속성 업데이트
// 2. token에 이벤트를 전달하여 vocabularies 변경

// 검색했을때 컬렉션뷰로 넘어가려면 리스트뷰모델에있는 단어들을 컬렉션뷰모델로 넘겨야하나?
