//
//  CategoryViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 20.07.2026.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    var onProductTapped: ((Product) -> Void)?
    
    private let viewModel: CategoryViewModelProtocol
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collection.backgroundColor = DesignSystem.Colors.primary
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.identifier
        )
        return collection
    }()
    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.loadProducts()
    }
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.primary
        view.addSubview(collectionView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    private func bindViewModel() {
        viewModel.onProductsUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "ОК",
                style: .default
            )
        )
        present(alert, animated: true)
    }
    private func createLayout() -> UICollectionViewLayout {
        let spacing = DesignSystem.Spacing.medium

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(
            group: group
        )

        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )

        return UICollectionViewCompositionalLayout(
            section: section
        )
    }
}
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.products.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let product = viewModel.products[indexPath.item]
        
        onProductTapped?(product)
    }
}
