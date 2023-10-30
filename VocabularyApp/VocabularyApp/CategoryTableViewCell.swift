//
//  CategoryTableViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/25/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
    public let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = appColor
        } else {
            contentView.backgroundColor = .tertiarySystemFill
        }
    }
    
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        contentView.backgroundColor = .tertiarySystemFill
        contentView.layer.cornerRadius = 8
        selectionStyle = .none
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
        
        setup()
        layout()
    }

}
