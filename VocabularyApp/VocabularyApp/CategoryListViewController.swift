//
//  CategoryListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/25/23.
//

import UIKit

class CategoryListViewController: UIViewController {
    
    // MARK: - Properties
    private let vm = CategoryListViewModel()
    
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
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addButtonClicked))
        button.tintColor = .appColor
        button.setTitleTextAttributes([.font:UIFont.boldSystemFont(ofSize: 17)], for: .normal)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        
        vm.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Helpers
extension CategoryListViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.setBackBarButtonItem()
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        return vm.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        let category = vm.categories[indexPath.row]
        cell.configure(with: category)
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.vm.deleteCategory(at: indexPath.row)
            
            success(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let category = self.vm.categories[indexPath.row]
            self.pushVC(title: "단어장 수정", category: category)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        vm.moveCategory(from: sourceIndexPath.row, to: destinationIndexPath.row)
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
    @objc private func addButtonClicked() {
        pushVC(title: "단어장 추가", category: nil)
    }
}
