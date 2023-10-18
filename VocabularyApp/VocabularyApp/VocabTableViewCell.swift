//
//  VocabCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/08.
//

import Foundation
import UIKit

class VocabTableViewCell: UITableViewCell {
    let vocabLabel = UILabel()
    var exampleLabel: UILabel?
    let meaningLabel = UILabel()
    let checkButton = UIButton(configuration: .plain())
    
    static let identifier = "VocabTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VocabTableViewCell {
    private func setup() {
        vocabLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.font = UIFont.systemFont(ofSize: 17)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black))
        checkButton.setImage(image, for: .normal)
        checkButton.tintColor = .systemGray2
        checkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        backgroundColor = .secondarySystemGroupedBackground
    }
        
    private func layout() {
        contentView.addSubview(vocabLabel)
        contentView.addSubview(meaningLabel)
        contentView.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            vocabLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 4),
            vocabLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            vocabLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor),
            
            meaningLabel.topAnchor.constraint(equalTo: vocabLabel.bottomAnchor),
            meaningLabel.leadingAnchor.constraint(equalTo: vocabLabel.leadingAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: meaningLabel.bottomAnchor, multiplier: 2),
            meaningLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor),
            
            checkButton.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: checkButton.trailingAnchor, multiplier: 2),
            
        ])
        checkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
}

extension VocabTableViewCell {
    @objc func buttonTapped() {
        if checkButton.tintColor == UIColor.systemGray2 {
            checkButton.tintColor = appColor
            vocabLabel.textColor = .systemGray2
            meaningLabel.textColor = .systemGray2
        } else {
            checkButton.tintColor = .systemGray2
            vocabLabel.textColor = .label
            meaningLabel.textColor = .label
        }
        
    }
}
