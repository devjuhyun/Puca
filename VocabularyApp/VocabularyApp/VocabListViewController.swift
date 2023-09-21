//
//  VocabListViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 2023/09/07.
//

import UIKit

class VocabListViewController: UIViewController {
    
    let tableView = UITableView()
    let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 56))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

extension VocabListViewController {
    private func setup() {
        setupTableView()
        setupAddButton()
        
        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VocabCell.self, forCellReuseIdentifier: VocabCell.reuseID)
        tableView.rowHeight = 80
        tableView.separatorInset = .init(top: .zero, left: 24, bottom: .zero, right: 24)
        tableView.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.configuration = .filled()
        addButton.tintColor = UIColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.clipsToBounds = true

        // shadow effect
//        addButton.layer.shadowColor = CGColor(red: 0.95, green: 0.63, blue: 0.62, alpha: 1.00)
//        addButton.layer.shadowOpacity = 1
//        addButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//        addButton.layer.shadowRadius = 4
        
        let image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)).withTintColor(.white, renderingMode: .alwaysOriginal)
        addButton.setImage(image, for: .normal)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
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
}

extension VocabListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VocabCell.reuseID, for: indexPath) as! VocabCell
        
        cell.vocabLabel.text = "hi puma"
        cell.meaningLabel.text = "안녕하세요 푸마씨"
        
        return cell
    }
    
}

extension VocabListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}

extension VocabListViewController {
    @objc func addButtonTapped() {
        print("add button tapped!")
    }
}
