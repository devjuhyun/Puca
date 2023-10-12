//
//  AddVocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/18.
//

import UIKit

class AddVocabViewController: UIViewController {
    
    let categoryLabel = UILabel()
    let categoryButton = UIButton()
    let vocabLabel = UILabel()
    let vocabTextField = UITextField()
    let meaningLabel = UILabel()
    let meaningTextField = UITextField()
    let exampleLabel = UILabel()
    let textView = UITextView()
    let placeholderLabel = UILabel()
    
    var cancelButton: UIBarButtonItem {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        
        return UIBarButtonItem(image: UIImage(systemName: "multiply", withConfiguration: configuration)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(cancelButtonClicked))
    }
    
    var addButton: UIBarButtonItem {
        let button = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addButtonClicked))
        button.tintColor = appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.topItem?.title = "새 단어"
        
        setup()
        layout()
    }
}

extension AddVocabViewController {
    private func setup() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "카테고리"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 17)
        categoryLabel.textColor = appColor
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.setTitle("영어", for: .normal)
        categoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        categoryButton.setTitleColor(.label, for: .normal)
        
        vocabLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabLabel.text = "단어"
        vocabLabel.font = UIFont.boldSystemFont(ofSize: 17)
        vocabLabel.textColor = appColor
        
        vocabTextField.translatesAutoresizingMaskIntoConstraints = false
        vocabTextField.placeholder = "단어를 입력하세요.(필수)"
        vocabTextField.font = UIFont.boldSystemFont(ofSize: 22)
        vocabTextField.delegate = self
        vocabTextField.becomeFirstResponder()
        
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.text = "의미"
        meaningLabel.font = UIFont.boldSystemFont(ofSize: 17)
        meaningLabel.textColor = appColor
        
        meaningTextField.translatesAutoresizingMaskIntoConstraints = false
        meaningTextField.placeholder = "뜻을 입력하세요.(필수)"
        meaningTextField.font = UIFont.boldSystemFont(ofSize: 22)
        meaningTextField.delegate = self

        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        exampleLabel.text = "예문"
        exampleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        exampleLabel.textColor = appColor
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.delegate = self
        
        placeholderLabel.text = "예문을 입력하세요."
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty

        view.backgroundColor = .systemBackground
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

extension AddVocabViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vocabTextField {
            meaningTextField.becomeFirstResponder()
        } else if textField == meaningTextField {
            textView.becomeFirstResponder()
        }
        
        return true
    }
}

extension AddVocabViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            vocabTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}

extension AddVocabViewController {
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        print("add button clicked!")
    }
}
