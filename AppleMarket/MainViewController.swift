//
//  MainViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
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
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystem.Colors.mainText
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Добро пожаловать в Apple Market"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "products")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI () {
        navigationItem.title = "Главная"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        view.addSubview(welcomeLabel)
        view.addSubview(productsImageView)
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
            
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 32),
            
            productsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productsImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
        ])
    }

}
