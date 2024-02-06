//
//  LanguageListViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/5/24.
//

import UIKit

class LanguageListViewCell: UITableViewCell {
    
    static let identifier = "LanguageListViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
    }
}
