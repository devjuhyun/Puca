//
//  AddVocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/18.
//

import UIKit

class AddVocabViewController: UIViewController {
    
    private let categoryLabel = ReusableLabel(text: "카테고리")
    
    private lazy var categoryButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("영어", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitleColor(.label, for: .normal)
        button.addAction(UIAction(handler: { UIAction in
            let vc = CategoryListViewController()
            vc.view.backgroundColor = .secondarySystemGroupedBackground
            vc.navigationItem.title = "카테고리 선택"
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private let vocabLabel = ReusableLabel(text: "단어")
    private let vocabTextField = ReusableTextField(placeholder: "단어를 입력하세요.(필수)")
    private let meaningLabel = ReusableLabel(text: "의미")
    private let meaningTextField = ReusableTextField(placeholder: "뜻을 입력하세요.(필수)")
    private let exampleLabel = ReusableLabel(text: "예문")
    
    public lazy var textView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.backgroundColor = view.backgroundColor
        return textView
    }()
    
    private lazy var placeholderLabel = {
        let label = UILabel()
        label.text = "예문을 입력하세요."
        label.font = textView.font
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        label.textColor = .tertiaryLabel
        label.isHidden = !textView.text.isEmpty
        return label
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonClicked))
        button.tintColor = appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

extension AddVocabViewController {
    private func setup() {
        if navigationItem.title == "단어 추가" {
            let cancelButton = UIBarButtonItem(image: UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(cancelButtonClicked))
            navigationItem.leftBarButtonItem = cancelButton
        }
        
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        button.tintColor = .label
        navigationItem.backBarButtonItem = button
        navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = .secondarySystemGroupedBackground
        
        vocabTextField.delegate = self
        vocabTextField.becomeFirstResponder()
        meaningTextField.delegate = self
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
    
    @objc func doneButtonClicked() {
        print(navigationItem.title!)
        //        dismiss(animated: true)
    }
}
