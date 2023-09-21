//
//  AddVocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/18.
//

import UIKit

class VocabViewController: UIViewController {
    
    let categoryLabel = UILabel()
    let categoryButton = UIButton()
    let vocabLabel = UILabel()
    let vocabTextField = UITextField()
    let meaningLabel = UILabel()
    let meaningTextField = UITextField()
    let exampleLabel = UILabel()
    let textView = UITextView()
    let placeholderLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

extension VocabViewController {
    private func setup() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "카테고리"
        categoryLabel.font = UIFont.systemFont(ofSize: 17)
        categoryLabel.textColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.setTitle("영어", for: .normal)
        categoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        categoryButton.setTitleColor(.systemBlue, for: .normal)
        
        vocabLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabLabel.text = "단어"
        vocabLabel.font = UIFont.systemFont(ofSize: 17)
        vocabLabel.textColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        
        vocabTextField.translatesAutoresizingMaskIntoConstraints = false
        vocabTextField.placeholder = "단어를 입력하세요.(필수)"
        vocabTextField.font = UIFont.boldSystemFont(ofSize: 22)
        
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.text = "의미"
        meaningLabel.font = UIFont.systemFont(ofSize: 17)
        meaningLabel.textColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        
        meaningTextField.translatesAutoresizingMaskIntoConstraints = false
        meaningTextField.placeholder = "뜻을 입력하세요.(필수)"
        meaningTextField.font = UIFont.boldSystemFont(ofSize: 22)

        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.text = "예문"
        exampleLabel.font = UIFont.systemFont(ofSize: 17)
        exampleLabel.textColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .secondarySystemGroupedBackground
        textView.isScrollEnabled = false
        textView.delegate = self
        
        placeholderLabel.text = "예문을 입력하세요."
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty


        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func layout() {
        view.addSubview(categoryLabel)
        view.addSubview(categoryButton)
        view.addSubview(vocabLabel)
        view.addSubview(vocabTextField)
        view.addSubview(meaningLabel)
        view.addSubview(meaningTextField)
        view.addSubview(exampleLabel)
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
            categoryLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            categoryButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            
            vocabLabel.topAnchor.constraint(equalToSystemSpacingBelow: categoryButton.bottomAnchor, multiplier: 1),
            vocabLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),

            vocabTextField.topAnchor.constraint(equalToSystemSpacingBelow: vocabLabel.bottomAnchor, multiplier: 1),
            vocabTextField.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: vocabTextField.trailingAnchor, multiplier: 2),

            meaningLabel.topAnchor.constraint(equalToSystemSpacingBelow: vocabTextField.bottomAnchor, multiplier: 2),
            meaningLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),

            meaningTextField.topAnchor.constraint(equalToSystemSpacingBelow: meaningLabel.bottomAnchor, multiplier: 1),
            meaningTextField.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: meaningTextField.trailingAnchor, multiplier: 2),
            
            exampleLabel.topAnchor.constraint(equalToSystemSpacingBelow: meaningTextField.bottomAnchor, multiplier: 2),
            exampleLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),

            textView.topAnchor.constraint(equalTo: exampleLabel.bottomAnchor),
            textView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.5),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: textView.trailingAnchor, multiplier: 1),
            
        ])
    }
}

extension VocabViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
        
}
