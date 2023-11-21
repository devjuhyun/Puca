//
//  CategoryListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/25/23.
//

import UIKit

class CategoryListViewController: UIViewController {
    
    let titles = ["영어", "일본어", "스페인어", "포르투갈어", "중국어"]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.backgroundColor = view.backgroundColor
        return tableView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addButtonClicked))
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
}

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
                
        cell.configure(titles[indexPath.row])
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete")
            
            success(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.pushVC(title: "단어장 수정")
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
}

extension CategoryListViewController {
    private func pushVC(title: String) {
        let vc = AddCategoryViewController()
        vc.navigationItem.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryListViewController {
    @objc func addButtonClicked() {
        pushVC(title: "단어장 추가")
    }
}
