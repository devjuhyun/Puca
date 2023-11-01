//
//  AddCategoryViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/30/23.
//

import UIKit

class AddCategoryViewController: UIViewController {
    private let nameLabel = ReusableLabel(text: "단어장 이름")
    private let nameTextField = ReusableTextField(placeholder: "단어장 이름을 입력하세요.")
    
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
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            nameTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nameTextField.trailingAnchor, multiplier: 2),

        ])
    }
}

extension AddCategoryViewController {
    @objc func doneButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
