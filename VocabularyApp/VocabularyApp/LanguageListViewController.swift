//
//  LanguageListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/5/24.
//

import UIKit

class LanguageListViewController: UIViewController {
    
    private let vm: LanguageListViewModel
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LanguageListViewCell.self, forCellReuseIdentifier: LanguageListViewCell.identifier)
        tableView.backgroundColor = view.backgroundColor
        return tableView
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshButtonClicked))
        button.tintColor = .label
        return button
    }()
        
    // MARK: - Lifecycle
    init(viewModel: LanguageListViewModel) {
        vm = viewModel
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

extension LanguageListViewController {
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.title = "Select Language".localized()
        navigationItem.setRightBarButtonItems([refreshButton], animated: true)
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableView Delegate Methods
extension LanguageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.identifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageListViewCell.identifier, for: indexPath) as! LanguageListViewCell
        
        cell.textLabel?.text = vm.getLanguage(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categoryVC = navigationController?.previousViewController as? CategoryViewController {
            let identifier = vm.identifiers[indexPath.row]
            
            if vm.isSelectingLanguage {
                categoryVC.vm.languageIdentifier.value = identifier
            } else {
                categoryVC.vm.nativeLanguageIdentifier.value = identifier
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return vm.titleForFooter
    }
}

// MARK: - Selectors
extension LanguageListViewController {
    @objc private func refreshButtonClicked() {
        vm.updateIdentifiers()
        tableView.reloadData()
    }
}
