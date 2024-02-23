//
//  VocabViewModelTests.swift
//  VocabularyAppUnitTests
//
//  Created by Juhyun Yun on 2/23/24.
//

import Foundation
import XCTest

@testable import VocabularyApp

class VocabViewModelTests: XCTestCase {
    var vm: VocabViewModel!
    
    override func setUp() {
        super.setUp()
        vm = VocabViewModel(selectedCategory: nil)
    }
    
    func testCategoryBlankSpace() throws {
        vm.checkBlankSpace(vocab: "test", meaning: "test", example: "test") { blankSpace, message, isSucceeded in
            XCTAssertEqual(blankSpace, .category)
            XCTAssertEqual(message, "Select a category.".localized())
            XCTAssertEqual(isSucceeded, false)
        }
    }
    
    func testVocabBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        vm.checkBlankSpace(vocab: "", meaning: "test", example: "test") { blankSpace, message, isSucceeded in
            XCTAssertEqual(blankSpace, .vocab)
            XCTAssertEqual(message, "Please enter a word.".localized())
            XCTAssertEqual(isSucceeded, false)
        }
    }
    
    func testMeaningBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        vm.checkBlankSpace(vocab: "test", meaning: "", example: "test") { blankSpace, message, isSucceeded in
            XCTAssertEqual(blankSpace, .meaning)
            XCTAssertEqual(message, "Please enter the meaning of the word.".localized())
            XCTAssertEqual(isSucceeded, false)
        }
    }
    
    func testNoBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        vm.checkBlankSpace(vocab: "test", meaning: "test", example: "test") { blankSpace, message, isSucceeded in
            XCTAssertEqual(blankSpace, nil)
            XCTAssertEqual(message, "You have successfully added a new word.".localized())
            XCTAssertEqual(isSucceeded, true)
        }
    }
}
