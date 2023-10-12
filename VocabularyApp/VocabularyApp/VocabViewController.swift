//
//  CardVocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/5/23.
//

import UIKit

class VocabViewController: UIViewController, UIGestureRecognizerDelegate {
    
    init(vocab: String, example: String? = nil, meaning: String, isChecked: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.vocab = vocab
        self.example = example
        self.meaning = meaning
        self.isChecked = isChecked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var vocab: String = "find"
    var example: String?
    var meaning: String = "찾다[발견하다]"
    var isChecked: Bool = false
    
    let card = UIView()
    let checkButton = UIButton(configuration: .plain())
    let stackView = UIStackView()
    let vocabLabel = UILabel()
    let exampleLabel = UILabel()
    let meaningLabel = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: checkButton) == false else { return false }
        
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromTop) {
            self.tapGestureRecognizer.isEnabled = false
        } completion: { _ in
            self.tapGestureRecognizer.isEnabled = true
        }
        
        vocabLabel.isHidden.toggle()
        exampleLabel.isHidden.toggle()
        meaningLabel.isHidden.toggle()
        
        return true
    }
}

extension VocabViewController {
    private func setup() {
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .secondarySystemGroupedBackground
        tapGestureRecognizer.delegate = self
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 20
        card.layer.borderColor = appColor.cgColor
        card.layer.borderWidth = 5
        card.isUserInteractionEnabled = true
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black))
        checkButton.setImage(image, for: .normal)
        checkButton.tintColor = .systemGray2
        checkButton.addAction(UIAction(handler: { UIAction in
            if self.checkButton.tintColor == .systemGray2 {
                self.checkButton.tintColor = appColor
            } else {
                self.checkButton.tintColor = .systemGray2
            }
        }), for: .touchUpInside)
        if isChecked {
            self.checkButton.tintColor = appColor
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        vocabLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabLabel.text = vocab
        vocabLabel.font = .boldSystemFont(ofSize: 30)
        
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.text = example
        
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.isHidden = true
        meaningLabel.text = meaning
        meaningLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    private func layout() {
        stackView.addArrangedSubview(vocabLabel)
        stackView.addArrangedSubview(exampleLabel)
        stackView.addArrangedSubview(meaningLabel)
        
        card.addSubview(checkButton)
        card.addSubview(stackView)
        
        view.addSubview(card)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            checkButton.topAnchor.constraint(equalToSystemSpacingBelow: card.topAnchor, multiplier: 2),
            card.trailingAnchor.constraint(equalToSystemSpacingAfter: checkButton.trailingAnchor, multiplier: 1),
            
            card.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 3),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: card.trailingAnchor, multiplier: 3),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
