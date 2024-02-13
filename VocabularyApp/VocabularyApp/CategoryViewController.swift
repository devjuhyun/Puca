//
//  AddCategoryViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/30/23.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    let vm: CategoryViewModel
    
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
    
    private let nameLabel = CustomLabel(text: "Name".localized())
    private let nameTextField = CustomTextField(placeholder: "Category Name".localized())
    private let languageLabel = CustomLabel(text: "Language You Are Learning".localized())
    
    private lazy var languageButton: UIButton = {
        let button = CustomButton()
        button.setTitle("Select Language".localized(), for: .normal)
        button.addTarget(self, action: #selector(languageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let nativeLanguageLabel = CustomLabel(text: "Native Language".localized())
    
    private lazy var nativeLanguageButton: UIButton = {
        let button = CustomButton()
        button.setTitle("Select Language".localized(), for: .normal)
        button.addTarget(self, action: #selector(nativeLanguageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(doneButtonClicked))
        button.tintColor = .appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CategoryViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

// MARK: - Helpers
extension CategoryViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.setBackBarButtonItem()
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        setupBindings()
    }
    
    private func setupBindings() {
        vm.category.bind { [weak self] category in
            if let category = category {
                self?.nameTextField.text = category.name
            }
        }
        
        vm.languageIdentifier.bind { [weak self] identifier in
            if let identifier = identifier {
                let language = LanguageManager.getLanguage(for: identifier)
                self?.languageButton.setTitle(language, for: .normal)
            }
        }
        
        vm.nativeLanguageIdentifier.bind { [weak self] identifier in
            if let identifier = identifier {
                let language = LanguageManager.getLanguage(for: identifier)
                self?.nativeLanguageButton.setTitle(language, for: .normal)
            }
        }
    }
    
    private func layout() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(languageLabel)
        stackView.addArrangedSubview(languageButton)
        stackView.addArrangedSubview(nativeLanguageLabel)
        stackView.addArrangedSubview(nativeLanguageButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 5),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            
        ])
    }
    
    private func saveCategory() {
        if nameTextField.text!.isEmpty {
            let toast = ToastView(message: "Enter a category name.".localized(), isGreen: false)
            AlertService.showToast(in: self, toastView: toast)
        } else {
            vm.updateCategory(name: nameTextField.text!)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveCategory()
        return true
    }
}

// MARK: - Selectors
extension CategoryViewController {
    @objc private func doneButtonClicked() {
        AlertService.playHaptics()
        saveCategory()
    }
    
    @objc private func languageButtonClicked() {
        AlertService.playHaptics()
        let vm = LanguageListViewModel(isSelectingLanguage: true)
        let vc = LanguageListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func nativeLanguageButtonClicked() {
        AlertService.playHaptics()
        let vm = LanguageListViewModel(isSelectingLanguage: false)
        let vc = LanguageListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
