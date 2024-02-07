//
//  LanguageListViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/5/24.
//

import UIKit

class LanguageListViewCell: UITableViewCell {
    
    static let identifier = "LanguageListViewCell"
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .appColor
        } else {
            contentView.backgroundColor = .tertiarySystemFill
        }
    }
}
