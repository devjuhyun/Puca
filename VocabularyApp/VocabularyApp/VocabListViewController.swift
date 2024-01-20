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
        tableView.separatorInset = .init(top: .zero, left: 24, bottom: .zero, right: 24)
        tableView.backgroundColor = view.backgroundColor
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = FloatingBtn(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        button.isHidden = tableView.isEditing
        button.addAction(UIAction(handler: { [weak self] UIAction in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            let category = self?.vm.passCategory()
            let vm = VocabViewModel(selectedCategory: category)
            let vc = VocabViewController(viewModel: vm)
            vc.navigationItem.title = "단어 추가"
            self?.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = CategoryBtn()
        button.addAction(UIAction(handler: { UIAction in
            let vm = CategoryListViewModel()
            vm.shouldDisplayAll = true
            let vc = CategoryListViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .appColor
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색할 단어를 입력하세요."
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    private lazy var searchButton: UIBarButtonItem = {
        let image = UIImage(systemName: "magnifyingglass")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let button = UIBarButtonItem(image: image, primaryAction: UIAction(handler: { _ in
            self.navigationItem.searchController = self.searchController
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.searchController.searchBar.searchTextField.becomeFirstResponder()
            }
            
        }))
        
        return button
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        let items = [
            UIMenu(title: "단어 정렬", subtitle: "최신순", image: UIImage(systemName: "arrow.up.arrow.down"), options: .singleSelection, children: [
                UIAction(title: "최신순", handler: { [weak self] _ in
                    self?.vm.updateCategory(sortOption: .newestFirst)
                }),
                UIAction(title: "오래된순", handler: { [weak self] _ in
                    self?.vm.updateCategory(sortOption: .oldestFirst)
                })
            ]),
            UIMenu(title: "단어 보기", subtitle: "모든 단어", image: UIImage(systemName: "eye"), options: .singleSelection, children: [
                UIAction(title: "모든 단어", state: .on, handler: { [weak self] _ in
                    self?.vm.updateCategory(displayOption: .all)
                }),
                UIAction(title: "체크한 단어", handler: { [weak self] _ in
                    self?.vm.updateCategory(displayOption: .checkedWords)
                }),
                UIAction(title: "미체크한 단어", handler: { [weak self] _ in
                    self?.vm.updateCategory(displayOption: .uncheckedWords)
                })
            ]),
            UIAction(title: "단어 선택", image: UIImage(systemName: "checkmark.circle"), handler: { UIAction in
                self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                self.updateUI()
            }),
        ]
        
        let button = UIBarButtonItem(image: image, menu: UIMenu(children: items))
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", primaryAction: UIAction(handler: { _ in
            self.tableView.setEditing(!self.tableView.isEditing, animated: true)
            self.updateUI()
        }))
        button.tintColor = .appColor
        
        return button
    }()
        
    private lazy var toolbarButtons: [UIBarButtonItem] = [
        UIBarButtonItem(image: UIImage(systemName: "checkmark.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(selectAllButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "folder")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(categoryMoveButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "trash")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(deleteButtonClicked)),
        .flexibleSpace(),
        UIBarButtonItem(image: UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(checkAllButtonClicked)),
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.searchController = nil
        if tableView.isEditing {
            tableView.setEditing(!tableView.isEditing, animated: true)
            updateUI()
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
        setupSearchBar()
    }
    
    private func setupBindings() {
        vm.vocabularies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        vm.selectedCategory.bind { [weak self] category in
            // TODO: - edit버튼 초기설정
            DispatchQueue.main.async {
                self?.categoryButton.setTitle(category.name, for: .normal)
                self?.vm.updateTokens()
            }
        }
        
        vm.onCategoryUpdated = { [weak self] in
            // TODO: - edit버튼 변경
            if let menu = self?.editButton.menu {
                
            }
        }
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
        toolbarItems = toolbarButtons
    }
    
    private func setupSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false // always show search controller
        searchController.searchBar.delegate = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func updateUI() {
        addButton.isHidden.toggle()
        navigationController?.isToolbarHidden.toggle()
        navigationItem.rightBarButtonItems = tableView.isEditing ? [doneButton] : [editButton, searchButton]
        navigationItem.leftBarButtonItems = tableView.isEditing ? nil : [.fixedSpace(16), UIBarButtonItem(customView: categoryButton)]
        navigationItem.searchController?.isActive = false // 검색하는 도중 편집할때 타이틀 안보이는 문제 해결
        navigationItem.searchController = tableView.isEditing ? self.searchController : nil
        navigationItem.title = self.tableView.isEditing ? "0/30" : nil
    }
}

// MARK: - TableView Delegate Methods
extension VocabListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.vocabularies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabTableViewCell.identifier, for: indexPath) as! VocabTableViewCell
                
        let vocab = vm.vocabularies.value[indexPath.row]
        cell.configure(with: vocab)
        cell.onChecked = { [weak self] in
            self?.vm.checkVocabulary(vocab)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            
        } else {
            let vm = VocabCollectionViewModel(category: vm.passCategory(), index: indexPath.row)
            let vc = VocabCollectionViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Selectors
extension VocabListViewController {
    @objc private func selectAllButtonClicked() {
    }
    
    @objc private func categoryMoveButtonClicked() {
    }
    
    @objc private func deleteButtonClicked() {
    }
    
    @objc private func checkAllButtonClicked() {
    }
}

// MARK: - Search Controller Funtions
extension VocabListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !tableView.isEditing {
            self.navigationItem.searchController = nil
        }
    }
}
