//
//  FavoritesViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleMarketLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "В избранном пока пусто. 😕"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: FavoritesViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        
        collection.backgroundColor = DesignSystem.Colors.primary
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.dataSource = self
        
        collection.register(
            FavoriteCell.self,
            forCellWithReuseIdentifier: FavoriteCell.identifier
        )
        
        return collection
    }()
    
    init(viewModel: FavoritesViewModelProtocol) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadFavorites()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        navigationItem.title = "Избранное"
        view.backgroundColor = DesignSystem.Colors.primary
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(
                equalTo: headerView.centerXAnchor
            ),
            logoImageView.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
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
            ),
            
            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            emptyLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            emptyLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -32
            )
        ])
    }
    
    private func bindViewModel() {
        
        viewModel.onProductsUpdated = { [weak self] in
            
            guard let self else {
                return
            }
            
            collectionView.reloadData()
            
            emptyLabel.isHidden = !viewModel.products.isEmpty
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
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 6,
            leading: 6,
            bottom: 6,
            trailing: 6
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(220)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        
        let section = NSCollectionLayoutSection(
            group: group
        )
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 8,
            bottom: 12,
            trailing: 8
        )
        
        return UICollectionViewCompositionalLayout(
            section: section
        )
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
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
            withReuseIdentifier: FavoriteCell.identifier,
            for: indexPath
        ) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        let product = viewModel.products[indexPath.item]
        
        cell.configure(
            with: product,
            isFavorite: viewModel.isFavorite(
                productID: product.id ?? ""
            )
        )
        
        cell.onFavoriteTapped = { [weak self] productID in
            
            self?.viewModel.toggleFavorite(
                productID: productID
            ) ?? false
        }
        
        return cell
    }
}
