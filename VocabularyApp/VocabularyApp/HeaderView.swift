//
//  HeaderView.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

class HeaderView: UIView {
    
    let categoryButton = UIButton()
    let sortButton = UIButton()
    let editButton = UIButton()
    let separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HeaderView {
    
    private func setup() {
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.setTitle("일상영단어" + " ", for: .normal)
        categoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        categoryButton.setTitleColor(.label, for: .normal)
        
        categoryButton.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration( weight: .bold)), for: .normal)
        categoryButton.adjustsImageWhenHighlighted = false
        categoryButton.semanticContentAttribute = .forceRightToLeft
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator

    }

    private func layout() {
        addSubview(categoryButton)
        addSubview(sortButton)
        addSubview(editButton)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalToSystemSpacingBelow: categoryButton.bottomAnchor, multiplier: 1),
            categoryButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            
            editButton.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            sortButton.leadingAnchor.constraint(equalToSystemSpacingAfter: editButton.trailingAnchor, multiplier: 2),
            
            sortButton.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: sortButton.trailingAnchor, multiplier: 2),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.widthAnchor.constraint(equalTo: widthAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}

