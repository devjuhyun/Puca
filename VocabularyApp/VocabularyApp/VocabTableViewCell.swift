//
//  VocabTableViewCell.swift
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
        tintColor = appColor
    }
        
    private func layout() {
        contentView.addSubview(vocabLabel)
        contentView.addSubview(meaningLabel)
        contentView.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            vocabLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 4),
            vocabLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            vocabLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor),
            
            meaningLabel.topAnchor.constraint(equalTo: vocabLabel.bottomAnchor),
            meaningLabel.leadingAnchor.constraint(equalTo: vocabLabel.leadingAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: meaningLabel.bottomAnchor, multiplier: 2),
            meaningLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor),
            
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: checkButton.trailingAnchor, multiplier: 2),
        ])
        
        checkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    public func configure(with vocab: Vocabulary) {
        setup()
        layout()
        
        vocabLabel.text = vocab.word
        meaningLabel.text = vocab.meaning
        updateUI(isChecked: vocab.isChecked)
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
        checkButton.isHidden.toggle()
    }
    
}

extension VocabTableViewCell {
    @objc func buttonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if checkButton.tintColor == UIColor.systemGray2 {
            updateUI(isChecked: true)
        } else {
            updateUI(isChecked: false)
        }
    }
    
    private func updateUI(isChecked: Bool) {
        checkButton.tintColor = isChecked ? appColor : .systemGray2
        vocabLabel.textColor = isChecked ? .systemGray2 : .label
        meaningLabel.textColor = isChecked ? .systemGray2 : .label
    }
}
