//
//  AddVocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/18.
//

import UIKit

class VocabViewController: UIViewController {    
    
    private let vm: VocabViewModel

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let categoryLabel = CustomLabel(text: "단어장")
    
    private lazy var categoryButton: UIButton = {
        let button = CategoryBtn()
        button.setTitle("단어장 선택" + " ", for: .normal)
        button.addAction(UIAction(handler: { UIAction in
            let vm = CategoryListViewModel()
            let vc = CategoryListViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        return button
    }()
        
    private let vocabLabel = CustomLabel(text: "단어")
    private let vocabTextField = CustomTextField(placeholder: "단어를 입력하세요.(필수)")
    private let meaningLabel = CustomLabel(text: "의미")
    private let meaningTextField = CustomTextField(placeholder: "뜻을 입력하세요.(필수)")
    private let exampleLabel = CustomLabel(text: "예문")
    
    private lazy var textView = {
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
        button.tintColor = .appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    // MARK: - lifecycle
    init(viewModel: VocabViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.selectedCategory.bind { [weak self] category in
            if let category = category {
                DispatchQueue.main.async {
                    self?.categoryButton.setTitle(category.name + " ", for: .normal)
                }
            }
        }
        
        setup()
        layout()
        addKeyboardObservers()
    }
}

extension VocabViewController {
    // MARK: - Helpers
    private func setup() {
        navigationItem.setBackBarButtonItem()
        navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = .secondarySystemGroupedBackground
        
        vocabTextField.delegate = self
        vocabTextField.becomeFirstResponder()
        meaningTextField.delegate = self
    }
    
    private func layout() {
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(categoryButton)
        stackView.addArrangedSubview(vocabLabel)
        stackView.addArrangedSubview(vocabTextField)
        stackView.addArrangedSubview(meaningLabel)
        stackView.addArrangedSubview(meaningTextField)
        stackView.addArrangedSubview(exampleLabel)
        textView.addSubview(placeholderLabel)

        contentView.addSubview(stackView)
        contentView.addSubview(textView)
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 5),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),

            textView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            textView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func updateUI() {
        
    }
}

// MARK: - UITextField Delegate Methods
extension VocabViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vocabTextField {
            meaningTextField.becomeFirstResponder()
        } else if textField == meaningTextField {
            textView.becomeFirstResponder()
        }
        
        return true
    }
}

// MARK: - UITextView Delegate Methods
extension VocabViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            updateUI()
        }
        
        return true
    }
    
}

// MARK: - Selectors
extension VocabViewController {
    @objc private func doneButtonClicked() {
        updateUI()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }

        scrollView.contentInset.bottom = keyboardFrame.size.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

}
