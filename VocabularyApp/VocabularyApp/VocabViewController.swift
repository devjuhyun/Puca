//
//  VocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/12/23.
//

import UIKit

class VocabViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(VocabCollectionViewCell.self, forCellWithReuseIdentifier: VocabCollectionViewCell.identifier)
        return collectionView
    }()
        
    private lazy var editButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        
        return UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(editButtonClicked))
    }()
    
    private lazy var deleteButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        
        return UIBarButtonItem(image: UIImage(systemName: "trash", withConfiguration: configuration)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(deleteButtonClicked))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
        
    // 선택한 단어로 이동
    override func viewDidAppear(_ animated: Bool) {
        collectionView.isPagingEnabled = false
        self.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: false)
        collectionView.isPagingEnabled = true
    }
}

extension VocabViewController {
    private func setup() {
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        navigationItem.setBackBarButtonItem()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension VocabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocabCollectionViewCell.identifier, for: indexPath) as? VocabCollectionViewCell else {
            fatalError("Failed to dequeue VocabCollectionViewCell")
        }
        
        let vocab = Vocabulary()
        vocab.word = "puma"
        vocab.example = "Puma is so cute"
        vocab.meaning = "푸마"
        vocab.isChecked = true
        cell.configure(with: vocab)
                
        return cell
    }
    
}

extension VocabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension VocabViewController {
    @objc func editButtonClicked() {
        let vc = AddVocabViewController()
        vc.navigationItem.title = "단어 수정"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteButtonClicked() {
        print("delete button clicked!")
    }
}
