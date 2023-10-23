//
//  ReusableTextField.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/23/23.
//

import UIKit

class ReusableTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 22)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

