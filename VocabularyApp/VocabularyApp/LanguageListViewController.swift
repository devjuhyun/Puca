//
//  LanguageListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2/5/24.
//

import UIKit

class LanguageListViewController: UIViewController {
    
    // MARK: - Properties
    private let vm = LanguageListVIewModel()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(LanguageListViewCell.self, forCellReuseIdentifier: LanguageListViewCell.identifier)
        tableView.backgroundColor = view.backgroundColor
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .appColor
        searchController.searchBar.placeholder = "Search languages".localized()
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        
        print(UITextInputMode.activeInputModes)
    }
}

extension LanguageListViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.title = "Select Language".localized()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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

extension LanguageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.languagesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageListViewCell.identifier, for: indexPath) as! LanguageListViewCell
        
        cell.textLabel?.text = vm.languagesToDisplay[indexPath.row]
        
        return cell
    }
}

extension LanguageListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        vm.setInSearchMode(isSearching: searchController.isActive, searchText: searchController.searchBar.text!)
        vm.updateSearchController(searchBarText: searchController.searchBar.text)
        tableView.reloadData()
    }
}
