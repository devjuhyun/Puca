//
//  CategoryTableViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/25/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CategoryTableViewCell"
    
    // MARK: - UI Components
    public let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Helpers
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .appColor
        } else {
            contentView.backgroundColor = .tertiarySystemFill
        }
    }
        
    private func layout() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
        ])
    }
    
    public func configure(_ text: String) {
        label.text = text
        label.textColor = .label
        isSelected = false
        
        layout()
    }

}
