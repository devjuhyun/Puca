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
        categoryButton.setTitle("모든 단어" + " ", for: .normal)
        categoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        categoryButton.setTitleColor(.label, for: .normal)
        
        categoryButton.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)), for: .normal)
        categoryButton.adjustsImageWhenHighlighted = false
        categoryButton.semanticContentAttribute = .forceRightToLeft
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)

    }

    private func layout() {
        addSubview(categoryButton)
        addSubview(sortButton)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalToSystemSpacingBelow: categoryButton.bottomAnchor, multiplier: 1),
            categoryButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            
            editButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            sortButton.leadingAnchor.constraint(equalToSystemSpacingAfter: editButton.trailingAnchor, multiplier: 1.5),
            
            sortButton.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: sortButton.trailingAnchor, multiplier: 2),
            
        ])
    }
}

