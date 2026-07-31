//
//  FavoritesViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "В избранном пока пусто. 😕"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI () {
        view.addSubview(emptyLabel)
        
        navigationItem.title = "Избранное"
        view.backgroundColor = DesignSystem.Colors.primary
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}
