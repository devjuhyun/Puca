//
//  BlankSpaceTests.swift
//  VocabularyAppUnitTests
//
//  Created by Juhyun Yun on 2/23/24.
//

import Foundation
import XCTest

@testable import VocabularyApp

class BlankSpaceTests: XCTestCase {
    var vm: VocabViewModel!
    
    override func setUp() {
        super.setUp()
        vm = VocabViewModel(selectedCategory: nil)
    }
    
    func testCategoryBlankSpace() throws {
        let (blankSpace, message, isSucceeded) = vm.checkBlankSpace(word: "", meaning: "", example: "")
        
        XCTAssertEqual(blankSpace, .category)
        XCTAssertEqual(message, "Select a category.".localized())
        XCTAssertEqual(isSucceeded, false)
    }
    
    func testVocabBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        let (blankSpace, message, isSucceeded) = vm.checkBlankSpace(word: "", meaning: "", example: "")
        
        XCTAssertEqual(blankSpace, .vocab)
        XCTAssertEqual(message, "Please enter a word.".localized())
        XCTAssertEqual(isSucceeded, false)
    }
    
    func testMeaningBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        let (blankSpace, message, isSucceeded) = vm.checkBlankSpace(word: "test", meaning: "", example: "")
        
        XCTAssertEqual(blankSpace, .meaning)
        XCTAssertEqual(message, "Please enter the meaning of the word.".localized())
        XCTAssertEqual(isSucceeded, false)
    }
    
    func testNoBlankSpace() throws {
        vm.selectedCategory.value = Category(name: "test")
        
        let (blankSpace, message, isSucceeded) = vm.checkBlankSpace(word: "test", meaning: "test", example: "")
        
        XCTAssertEqual(blankSpace, nil)
        XCTAssertEqual(message, "You have successfully added a new word.".localized())
        XCTAssertEqual(isSucceeded, true)
    }
}
