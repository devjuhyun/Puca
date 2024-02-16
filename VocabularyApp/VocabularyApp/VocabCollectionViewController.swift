//
//  VocabViewController.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 10/12/23.
//

import UIKit

class VocabCollectionViewController: UIViewController {
    
    private let vm: VocabCollectionViewModel
    
    // MARK: - UI Components
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
    
    // MARK: - Lifecycle
    init(viewModel: VocabCollectionViewModel) {
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let vocabListVC = navigationController?.topViewController as? VocabListViewController {
            // update filtered vocabulries in vocab list view model
            vocabListVC.vm.updateSearchController(searchBarText: vm.searchText)
        }
    }
        
}

// MARK: - Helpers
extension VocabCollectionViewController {
    private func setup() {
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        navigationItem.setBackBarButtonItem()
        setupBindings()
    }
    
    private func setupBindings() {
        vm.vocabularies.bind { [weak self] vocabularies in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.navigationItem.title = self.vm.navTitle
                if vocabularies.isEmpty && !self.vm.isFirstLoad {
                    self.navigationItem.title = "0/0"
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        vm.currentIndex.bind { [weak self] index in
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.vm.navTitle
            }
        }
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
    
    private func updateCurrentIndex() {
        let xPoint = collectionView.contentOffset.x + collectionView.frame.width / 2
        let yPoint = collectionView.frame.height / 2
        let center = CGPoint(x: xPoint, y: yPoint)
        
        if let indexPath = collectionView.indexPathForItem(at: center) {
            vm.currentIndex.value = indexPath.row
        }
    }
}

// MARK: - CollectionView Delegate Methods
extension VocabCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.vocabularies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocabCollectionViewCell.identifier, for: indexPath) as? VocabCollectionViewCell else {
            fatalError("Failed to dequeue VocabCollectionViewCell")
        }
        
        let vocab = vm.vocabularies.value[indexPath.row]
        cell.configure(with: vocab)
        cell.onChecked = { [weak self] in
            AlertService.playHaptics()
            self?.vm.checkVocabulary(vocab)
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if vm.isFirstLoad {
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(row: vm.currentIndex.value, section: 0), at: .left, animated: false)
            collectionView.isPagingEnabled = true
            vm.isFirstLoad = false
        }
    }
}

extension VocabCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - ScrollView Delegate Methods
extension VocabCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
}

// MARK: - Selectors
extension VocabCollectionViewController {
    @objc private func editButtonClicked() {
        AlertService.playHaptics()
        let vm = VocabViewModel(selectedCategory: vm.category, selectedVocab: vm.vocabularies.value[vm.currentIndex.value])
        let vc = VocabViewController(viewModel: vm)
        vc.navigationItem.title = "Edit Word".localized()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func deleteButtonClicked() {
        AlertService.playHaptics()
        let alertController = AlertService.deleteAlert(deleteOption: .vocabulary) { [weak self] _ in
            self?.vm.deleteVocabulary()
            self?.updateCurrentIndex()
        }
        
        present(alertController, animated: true)
    }
}
