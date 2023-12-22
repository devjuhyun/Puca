//
//  AddCategoryViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/30/23.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameLabel = CustomLabel(text: "단어장 이름")
    private let nameTextField = CustomTextField(placeholder: "단어장 이름을 입력하세요.")
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonClicked))
        button.tintColor = .appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

// MARK: - Helpers
extension AddCategoryViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.rightBarButtonItem = doneButton
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
    }
    
    private func layout() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 5),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            
        ])
    }
    
    private func saveCategory() {
        if nameTextField.text!.isEmpty {
            AlertService.showToast(in: self, message: "단어장 이름을 입력하세요.", color: .systemRed, imageName: "x.circle")
        } else {
            let newCategory = Category(name: nameTextField.text!)
            DatabaseManager.shared.create(newCategory)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveCategory()
        return true
    }
}

// MARK: - Selectors
extension AddCategoryViewController {
    @objc private func doneButtonClicked() {
        saveCategory()
    }
}
