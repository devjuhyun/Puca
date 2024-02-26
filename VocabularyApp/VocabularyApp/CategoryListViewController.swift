//
//  CategoryListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/25/23.
//

import UIKit

class CategoryListViewController: UIViewController {
    
    // MARK: - Properties
    private let vm: CategoryListViewModel
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.rowHeight = 60
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.backgroundColor = view.backgroundColor
        return tableView
    }()
    
    private let emptyView = EmptyView(title: "No categories.".localized(), message: "Add new category by clicking the add button.".localized())
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add".localized(), style: .done, target: self, action: #selector(addButtonClicked))
        button.tintColor = .appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CategoryListViewModel) {
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
        
        vm.categories.bind { [weak self] categories in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.emptyView.isHidden = !categories.isEmpty
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
    
}

// MARK: - Helpers
extension CategoryListViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.setBackBarButtonItem()
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Select Category".localized()
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: emptyView.trailingAnchor, multiplier: 2),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func pushVC(title: String, category: Category?) {
        let vm = CategoryViewModel(category: category)
        let vc = CategoryViewController(viewModel: vm)
        vc.navigationItem.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableView Delegate Methods
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        let category = vm.categories.value[indexPath.row]
        let name = vm.shouldDisplayAll && indexPath.row == 0 ? category.name.localized() : category.name
        let count = vm.shouldDisplayAll && indexPath.row == 0 ? vm.total : category.vocabularies.count
        cell.configure(name: name, count: count)
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let vocabListVC = navigationController?.viewControllers.first as? VocabListViewController
        
        let alertController = AlertService.deleteAlert(deleteOption: .category) { [weak self] _ in
            vocabListVC?.vm.resetCategory()
            self?.vm.deleteCategory(at: indexPath.row)
        }
        
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.present(alertController, animated: true)
            success(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let category = self.vm.categories.value[indexPath.row]
            self.pushVC(title: "Edit Category".localized(), category: category)
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        
        edit.backgroundColor = .systemOrange
        edit.image = UIImage(systemName: "pencil")
        
        let swipeAction = UISwipeActionsConfiguration(actions:[delete, edit])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        vm.canEditRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = vm.categories.value[indexPath.row]
        if let vocabListVC = navigationController?.previousViewController as? VocabListViewController {
            if vm.shouldDisplayAll { // change category
                UserDefaults.standard.set(indexPath.row, forKey: "recentCategoryIndex")
                vocabListVC.vm.shouldDisplayAllVocabulariesInDB = indexPath.row == 0
                vocabListVC.vm.category.value = selectedCategory
            } else { // move vocabularies
                vocabListVC.vm.moveVocabularies(to: selectedCategory)
                navigationController?.isToolbarHidden = false
                vocabListVC.updateUI()
            }
        }
        
        if let vocabVC = navigationController?.previousViewController as? VocabViewController {
            vocabVC.vm.selectedCategory.value = selectedCategory
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        vm.moveCategory(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        vm.canEditRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        vm.getTargetIndexPath(sourceIndexPath: sourceIndexPath, proposedDestinationIndexPath: proposedDestinationIndexPath)
    }
}

extension CategoryListViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
}

// MARK: - Selectors
extension CategoryListViewController {
    @objc func addButtonClicked() {
        AlertService.playHaptics()
        pushVC(title: "Add New Category".localized(), category: nil)
    }
}
