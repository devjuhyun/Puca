//
//  AddCategoryViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/30/23.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
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

extension AddCategoryViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.rightBarButtonItem = doneButton
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
}

extension AddCategoryViewController {
    @objc private func doneButtonClicked() {
        showToast(message: "단어장 이름을 입력하세요.", color: .red)
    }
}
