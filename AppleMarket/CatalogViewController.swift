//
//  CatalogViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    private let categories: [CatalogCategory] = [
        .init(title: "iPhone", imageName: "iphone"),
        .init(title: "iPad", imageName: "ipad"),
        .init(title: "Mac", imageName: "mac"),
        .init(title: "Apple Watch", imageName: "applewatch"),
        .init(title: "AirPods", imageName: "airpods"),
        .init(title: "Аксессуары", imageName: "accessories"),
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
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing = DesignSystem.Spacing.medium
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(180)
                                              )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(180)
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

        print(category.title)
    }
}
