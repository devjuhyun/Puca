//
//  CustomTextField.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/23/23.
//

import UIKit

class CustomTextField: UITextField {
    
    private let language: String?
    
    init(placeholder: String, keyboardLanguage: String? = nil) {
        self.language = keyboardLanguage
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 20)
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

