//
//  AvatarViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.07.2026.
//

import UIKit

final class AvatarViewController: UIViewController {
    
    // MARK: - Properties
    
    private let avatars = Avatar.allCases
    private let completion: (Avatar) -> Void
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            AvatarCell.self,
            forCellWithReuseIdentifier: "AvatarCell"
        )
        
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = DesignSystem.Colors.mainText
        label.text = "Аватары"
        return label
    }()
    
    // MARK: - Init
    
    init(completion: @escaping (Avatar) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else {
            return
        }
        
        let columns: CGFloat = 3
        let spacing: CGFloat = 16
        
        let availableWidth =
            collectionView.bounds.width
            - spacing * (columns - 1)
        
        let itemWidth = floor(availableWidth / columns)
        
        layout.itemSize = CGSize(
            width: itemWidth,
            height: itemWidth
        )
    }
    
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension AvatarViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        avatars.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AvatarCell",
            for: indexPath
        ) as? AvatarCell else {
            return UICollectionViewCell()
        }
        
        let avatar = avatars[indexPath.item]
        
        cell.configure(with: avatar)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let avatar = avatars[indexPath.item]
        
        completion(avatar)
        
        dismiss(animated: true)
    }
}
