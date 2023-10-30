//
//  HeaderView.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/26.
//

import UIKit

class HeaderView: UIView {
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("일상영단어" + " ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.label, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration( weight: .bold)), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.semanticContentAttribute = .forceRightToLeft
        button.addAction(UIAction(handler: { UIAction in
            NotificationCenter.default.post(name: .category, object: nil)
        }), for: .touchUpInside)
        return button
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
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
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func layout() {
        addSubview(categoryButton)
        addSubview(sortButton)
        addSubview(editButton)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalToSystemSpacingBelow: categoryButton.bottomAnchor, multiplier: 1.5),
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

