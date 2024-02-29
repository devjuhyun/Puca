//
//  CustomTextField.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/23/23.
//

import UIKit

class CustomTextField: UITextField {
    
    private var language: String? = nil
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 21)
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setKeyboardLanguage(_ language: String?) {
        self.language = language
    }
    
    override var textInputMode: UITextInputMode? {
        for inputMode in UITextInputMode.activeInputModes {
            if inputMode.primaryLanguage! == language {
                return inputMode
            }
        }
        return super.textInputMode
    }
}

