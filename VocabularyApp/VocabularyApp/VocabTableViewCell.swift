//
//  VocabTableViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/08.
//

import UIKit

class VocabTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "VocabTableViewCell"
    var onChecked: (()->Void)?
    
    // MARK: - UI Components
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
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
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
    // MARK: - Helpers
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        tintColor = .appColor
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
    
    public func configure(with vocabulary: Vocabulary) {
        vocabLabel.text = vocabulary.word
        meaningLabel.text = vocabulary.meaning
        
        checkButton.tintColor = vocabulary.isChecked ? .appColor : .systemGray2
        vocabLabel.textColor = vocabulary.isChecked ? .systemGray2 : .label
        meaningLabel.textColor = vocabulary.isChecked ? .systemGray2 : .label
    }
    
    // MARK: - UITableViewCell Methods
    override func prepareForReuse() {
        isSelected = false
    }
}

// MARK: - Selectors
extension VocabTableViewCell {
    @objc func checkButtonTapped() {
        AlertService.playHaptics()
        onChecked?()
    }
}
