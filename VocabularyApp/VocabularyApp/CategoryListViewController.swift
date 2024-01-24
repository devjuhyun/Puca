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
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addButtonClicked))
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
        
        vm.categories.bind { [weak self] _ in
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
        navigationItem.title = "단어장 선택"
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
        return vm.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        let category = vm.categories.value[indexPath.row]
        cell.configure(with: category)
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alertController = AlertService.deleteAlert(deleteOption: .category) { [weak self] _ in
            self?.vm.deleteCategory(at: indexPath.row)
        }
        
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.present(alertController, animated: true)
            success(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let category = self.vm.categories.value[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        vm.canEditRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = vm.categories.value[indexPath.row]
        if let vocabListVC = navigationController?.previousViewController as? VocabListViewController {
            // TODO: - 단어 이동할때는 Userdefaults 값을 변경하면 안되게 하기
            UserDefaults.standard.set(indexPath.row, forKey: "recentCategoryIndex")
            vocabListVC.vm.selectedCategory.value = selectedCategory
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
    @objc private func addButtonClicked() {
        pushVC(title: "단어장 추가", category: nil)
    }
}
