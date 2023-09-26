//
//  VocabListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

class VocabListViewController: UIViewController {
    
    let tableView = UITableView()
    let headerView = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

extension VocabListViewController {
    private func setup() {
        setupHeaderView()
        setupTableView()
        
        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VocabCell.self, forCellReuseIdentifier: VocabCell.reuseID)
        tableView.rowHeight = 80
        tableView.separatorInset = .init(top: .zero, left: 24, bottom: .zero, right: 24)
        tableView.backgroundColor = view.backgroundColor
    }
        
    private func layout() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 40),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension VocabListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabCell.reuseID, for: indexPath) as! VocabCell
        
        cell.vocabLabel.text = "ensue"
        cell.meaningLabel.text = "(어떤 일·결과가) 뒤따르다"
        
        return cell
    }
    
}

extension VocabListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
