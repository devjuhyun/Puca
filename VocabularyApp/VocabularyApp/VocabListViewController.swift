//
//  VocabListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

protocol VocabListViewControllerDelegate: AnyObject {
    func didSelectVocab()
}

class VocabListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VocabTableViewCell.self, forCellReuseIdentifier: VocabTableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorInset = .init(top: .zero, left: 24, bottom: .zero, right: 24)
        tableView.backgroundColor = view.backgroundColor
        return tableView
    }()
    
    private let headerView = HeaderView()
    weak var delegate: VocabListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

extension VocabListViewController {
    private func setup() {
        view.backgroundColor = .secondarySystemGroupedBackground
    }
        
    private func layout() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension VocabListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabTableViewCell.identifier, for: indexPath) as! VocabTableViewCell
        
        let vocab = Vocabulary()
        vocab.word = "puma"
        vocab.example = "Puma is so cute"
        vocab.meaning = "푸마"
        vocab.isChecked = false
        cell.configure(with: vocab)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectVocab()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
}
