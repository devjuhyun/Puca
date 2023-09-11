//
//  VocabListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

class VocabListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

}

extension VocabListViewController {
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VocabCell.self, forCellReuseIdentifier: VocabCell.reuseID)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension VocabListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabCell.reuseID, for: indexPath)
        
        cell.textLabel?.text = "Hello, World"
        
        return cell
    }
    
}

extension VocabListViewController: UITableViewDelegate {
    
}
