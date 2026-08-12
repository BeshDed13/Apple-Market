//
//  CatalogViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class CatalogViewController: UIViewController {
    
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
    
    var onCategoryTapped: ((CatalogCategory) -> Void)?
    
    private let categories: [CatalogCategory] = [
        .init(id: "iphone", title: "iPhone", imageName: "iphone"),
        .init(id: "ipad", title: "iPad", imageName: "ipad"),
        .init(id: "mac", title: "Mac", imageName: "mac"),
        .init(id: "watch", title: "Apple Watch", imageName: "applewatch"),
        .init(id: "airpods", title: "AirPods", imageName: "airpods"),
        .init(id: "accessories", title: "Аксессуары", imageName: "accessories")
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = DesignSystem.Colors.primary
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(CatalogCategoryCell.self, forCellWithReuseIdentifier: CatalogCategoryCell.identifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI () {
        navigationItem.title = "Каталог"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(collectionView)
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing = DesignSystem.Spacing.small
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(200)
                                              )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension CatalogViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CatalogCategoryCell.identifier,
            for: indexPath
        ) as? CatalogCategoryCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: categories[indexPath.item])

        return cell
    }
}

extension CatalogViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let category = categories[indexPath.item]
        onCategoryTapped?(category)
    }
}
