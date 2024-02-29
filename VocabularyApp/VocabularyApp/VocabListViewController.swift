//
//  VocabListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

class VocabListViewController: UIViewController {
    
    let vm: VocabListViewModel
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VocabTableViewCell.self, forCellReuseIdentifier: VocabTableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        tableView.backgroundColor = view.backgroundColor
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        return tableView
    }()
    
    private let emptyView = EmptyView(title: "No words to display.".localized(), message: "Add new word by clicking the plus button or change the display option.".localized())
    
    private lazy var addButton: UIButton = {
        let button = FloatingBtn(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        button.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = CustomButton()
        button.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .appColor
        searchController.searchBar.placeholder = "Search words".localized()
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    private lazy var searchButton: UIBarButtonItem = {
        let image = UIImage(systemName: "magnifyingglass")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(searchButtonClicked))
        button.tintColor = .label
        return button
    }()
    
    private lazy var menuItems = [
        UIMenu(title: "Sort By".localized(), image: UIImage(systemName: "arrow.up.arrow.down"), options: .singleSelection, children: [
            UIAction(title: "Newest First".localized(), handler: { [weak self] _ in
                self?.vm.updateSortOption(.newestFirst)
            }),
            UIAction(title: "Oldest First".localized(), handler: { [weak self] _ in
                self?.vm.updateSortOption(.oldestFirst)
            })
        ]),
        UIMenu(title: "Display Option".localized(), image: UIImage(systemName: "eye"), options: .singleSelection, children: [
            UIAction(title: "All".localized(), state: .on, handler: { [weak self] _ in
                self?.vm.updateDisplayOption(.all)
            }),
            UIAction(title: "Checked Words".localized(), handler: { [weak self] _ in
                self?.vm.updateDisplayOption(.checkedWords)
            }),
            UIAction(title: "Unchecked Words".localized(), handler: { [weak self] _ in
                self?.vm.updateDisplayOption(.uncheckedWords)
            })
        ]),
        UIAction(title: "Select Words".localized(), image: UIImage(systemName: "checkmark.circle"), handler: { [weak self] _ in
            self?.updateUI()
        })
    ]
    
    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis")
        let button = UIBarButtonItem(image: image, menu: UIMenu(children: menuItems))
        button.tintColor = .label
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(doneButtonClicked))
        button.tintColor = .appColor
        return button
    }()
        
    private lazy var toolbarButtons: [UIBarButtonItem] = [
        UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(selectAllButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(moveButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(checkAllButtonClicked)),
    ]
            
    // MARK: - Lifecycle
    init(viewModel: VocabListViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBManager.shared.getLocationOfDefaultRealm()
        
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableView.isEditing {
            navigationController?.isToolbarHidden = false
        }
    }
}

// MARK: - Helpers
extension VocabListViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        setupBindings()
        setupNavBar()
        setupToolBar()
    }
    
    private func setupBindings() {
        let menuItems = editButton.menu!.children
        vm.vocabularies.bind { [weak self] vocabularies in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.emptyView.isHidden = !vocabularies.isEmpty
                let selectWordsButton = menuItems[2] as? UIAction
                selectWordsButton?.attributes = vocabularies.isEmpty ? .disabled : .keepsMenuPresented
            }
        }
        
        vm.filteredVocabularies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        vm.category.bind { [weak self] category in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let title = self.vm.shouldDisplayAllVocabulariesInDB ? category.name.localized() : category.name
                self.categoryButton.setTitle(title, for: .normal)
                self.vm.fetchVocabularies()
            }
        }
        
        vm.sortOption.bind { [weak self] _ in
            self?.vm.fetchVocabularies()
            self?.updateMenu(at: 0)
        }
        
        vm.displayOption.bind { [weak self] _ in
            self?.vm.fetchVocabularies()
            self?.updateMenu(at: 1)
        }
        
        vm.selectedVocabularies.bind { [weak self] _ in
            self?.updateToolbarAndNavigationTitle()
        }
    }
    
    private func updateMenu(at menuIndex: Int) {
        let (subtitle, actionIndex) = menuIndex == 0 ? vm.getSubtitleAndActionIndexOfSortMenu() : vm.getSubtitleAndActionIndexOfDisplayMenu()
        let menuItems = editButton.menu!.children
        let menu = menuItems[menuIndex] as? UIMenu
        let action = menu?.children[actionIndex] as? UIAction
        menu?.subtitle = subtitle
        action?.state = .on
    }
    
    private func updateToolbarAndNavigationTitle() {
        [2, 4, 6].forEach { toolbarButtons[$0].isEnabled = !vm.selectedVocabularies.value.isEmpty }
        if tableView.isEditing { navigationItem.title = vm.navTitle }
    }
    
    private func setupNavBar() {
        navigationItem.setBackBarButtonItem()
        navigationItem.leftBarButtonItems = [.fixedSpace(16), UIBarButtonItem(customView: categoryButton)]
        navigationItem.rightBarButtonItems = [editButton, searchButton]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupToolBar() {
        let apperance = UIToolbarAppearance()
        apperance.backgroundColor = .appColor
        navigationController?.toolbar.standardAppearance = apperance
        navigationController?.toolbar.scrollEdgeAppearance = apperance
        toolbarButtons.forEach { $0.tintColor = .label }
        toolbarItems = toolbarButtons
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: emptyView.trailingAnchor, multiplier: 2),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func updateUI() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        addButton.isHidden.toggle()
        navigationController?.isToolbarHidden.toggle()
        navigationItem.rightBarButtonItems = tableView.isEditing ? [doneButton] : [editButton, searchButton]
        navigationItem.leftBarButtonItems = tableView.isEditing ? nil : [.fixedSpace(16), UIBarButtonItem(customView: categoryButton)]
        navigationItem.title = tableView.isEditing ? vm.navTitle : nil
        navigationController?.navigationBar.layoutSubviews()
        vm.updateSelectedVocabularies(indexPaths: tableView.indexPathsForSelectedRows)
    }
}

// MARK: - TableView Delegate Methods
extension VocabListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.vocabulariesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabTableViewCell.identifier, for: indexPath) as! VocabTableViewCell
                
        // prevent error when vocabularies are changed in VocabCollectionVC
        if let vocabulary = vm.vocabulariesToDisplay[safe: indexPath.row] {
            cell.configure(with: vocabulary)
            cell.onChecked = { [weak self] in
                if !tableView.isEditing {
                    AlertService.playHaptics()
                    self?.vm.checkVocabulary(vocabulary)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            vm.updateSelectedVocabularies(indexPaths: tableView.indexPathsForSelectedRows)
        } else {
            let vm = VocabCollectionViewModel(category: vm.passCategory(), index: indexPath.row, sortOption: vm.sortOption.value, displayOption: vm.displayOption.value, searchText: vm.inSearchMode ? searchController.searchBar.text : nil)
            let vc = VocabCollectionViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        vm.updateSelectedVocabularies(indexPaths: tableView.indexPathsForSelectedRows)
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Selectors
extension VocabListViewController {
    @objc func addButtonClicked() {
        AlertService.playHaptics()
        let category = vm.passCategory()
        let vm = VocabViewModel(selectedCategory: category)
        let vc = VocabViewController(viewModel: vm)
        vc.navigationItem.title = "Add New Word".localized()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryButtonClicked() {
        AlertService.playHaptics()
        let vm = CategoryListViewModel(shouldDisplayAll: true)
        let vc = CategoryListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButtonClicked() {
        AlertService.playHaptics()
        navigationItem.searchController = searchController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak self] in
            self?.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    @objc func doneButtonClicked() {
        AlertService.playHaptics()
        updateUI()
    }
    
    @objc func selectAllButtonClicked() {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        if tableView.indexPathsForSelectedRows?.count == numberOfRows {
            for row in 0..<numberOfRows {
                tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            }
        } else {
            for row in 0..<numberOfRows {
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
            }
        }
        vm.updateSelectedVocabularies(indexPaths: tableView.indexPathsForSelectedRows)
    }
    
    @objc func moveButtonClicked() {
        let vm = CategoryListViewModel(shouldDisplayAll: false)
        let vc = CategoryListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteButtonClicked() {
        let alertController = AlertService.deleteAlert(deleteOption: .vocabularies) { [weak self] _ in
            self?.vm.deleteVocabularies()
            self?.updateUI()
        }
        present(alertController, animated: true)
    }
    
    @objc func checkAllButtonClicked() {
        let alertController = AlertService.checkAlert { [weak self] _ in
            self?.vm.checkSelectedVocabularies(isChecking: true)
            self?.updateUI()
        } unCheckActionHandler: { [weak self] _ in
            self?.vm.checkSelectedVocabularies(isChecking: false)
            self?.updateUI()
        }
                
        present(alertController, animated: true)
    }
}

// MARK: - Search Controller Methods
extension VocabListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        vm.setInSearchMode(isSearching: searchController.isActive, searchText: searchController.searchBar.text!)
        vm.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
    }
}
