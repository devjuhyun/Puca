//
//  VocabCollectionViewCell.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/16/23.
//

import UIKit

class VocabCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "VocabCollectionViewCell"
    
    // MARK: - UI Components
    private let card: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.appColor.cgColor
        view.layer.borderWidth = 5
        //        card.isUserInteractionEnabled = true
        return view
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black))
        button.setImage(image, for: .normal)
        button.addAction(UIAction(handler: { UIAction in
            if button.tintColor == .systemGray2 {
                button.tintColor = .appColor
            } else {
                button.tintColor = .systemGray2
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let vocabLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let exampleLabel = UILabel()
    
    private let meaningLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VocabCollectionViewCell {
    // MARK: - Helpers
    private func setup() {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        backgroundColor = .secondarySystemGroupedBackground
        tap.addTarget(self, action: #selector(flip))
    }
    
    private func layout() {
        stackView.addArrangedSubview(vocabLabel)
        stackView.addArrangedSubview(exampleLabel)
        stackView.addArrangedSubview(meaningLabel)
        
        card.addSubview(checkButton)
        card.addSubview(stackView)
        
        addSubview(card)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            checkButton.topAnchor.constraint(equalToSystemSpacingBelow: card.topAnchor, multiplier: 2),
            card.trailingAnchor.constraint(equalToSystemSpacingAfter: checkButton.trailingAnchor, multiplier: 1),
            
            card.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            trailingAnchor.constraint(equalToSystemSpacingAfter: card.trailingAnchor, multiplier: 3),
            card.centerYAnchor.constraint(equalTo: centerYAnchor),
            card.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    public func configure(with vocab: Vocabulary) {
        vocabLabel.text = vocab.word
        exampleLabel.text = vocab.example
        meaningLabel.text = vocab.meaning
        meaningLabel.isHidden = true
        checkButton.tintColor = vocab.isChecked ? .appColor : UIColor.systemGray2
    }
    
    // MARK: - UICollectionViewCell Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        vocabLabel.text = ""
        exampleLabel.text = ""
        meaningLabel.text = ""
        checkButton.tintColor = .systemGray2
    }
}

// MARK: - Selectors
extension VocabCollectionViewCell {
    @objc private func flip() {
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromBottom) {
            self.isUserInteractionEnabled = false
        } completion: { _ in
            self.isUserInteractionEnabled = true
        }
        
        vocabLabel.isHidden.toggle()
        exampleLabel.isHidden.toggle()
        meaningLabel.isHidden.toggle()
    }
}
