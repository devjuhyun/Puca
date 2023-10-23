//
//  VocabCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/08.
//

import UIKit

class VocabTableViewCell: UITableViewCell {
    
    static let identifier = "VocabTableViewCell"
    
    public let vocabLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    public let meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    public lazy var checkButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black))
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
}

extension VocabTableViewCell {
    private func setup() {
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
    
    public func configure(with vocab: Vocabulary) {
        setup()
        layout()
        
        vocabLabel.text = vocab.word
        meaningLabel.text = vocab.meaning

        if vocab.isChecked {
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
