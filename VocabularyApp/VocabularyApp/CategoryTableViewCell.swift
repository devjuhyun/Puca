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
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let imgView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            countLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            
            countLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            
            imgView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            imgView.leadingAnchor.constraint(equalToSystemSpacingAfter: countLabel.trailingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: imgView.trailingAnchor, multiplier: 2)
        ])
        
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        imgView.setContentHuggingPriority(.required, for: .horizontal)
        imgView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    public func configure(name: String, count: Int) {
        nameLabel.text = name
        countLabel.text = "\(count) words"
    }
    
    // MARK: - UITableViewCell Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .appColor
        } else {
            contentView.backgroundColor = .tertiarySystemFill
        }
    }

}
