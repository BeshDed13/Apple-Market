//
//  MainViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignSystem.Colors.secondaryText
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Более 10 лет мы занимаемся техникой Apple, помогая нашим клиентам выбирать устройства, которые действительно подходят им. В AppleMarket собраны iPhone, iPad, Mac, AirPods, Apple Watch и аксессуары — всё необходимое для вашей экосистемы Apple"
        label.numberOfLines = 0
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupUI () {
        navigationItem.title = "Главная"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        view.addSubview(welcomeLabel)
        view.addSubview(productsImageView)
        view.addSubview(descriptionLabel)
        headerView.addSubview(logoImageView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            welcomeLabel.topAnchor.constraint(equalTo: productsImageView.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            productsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            productsImageView.heightAnchor.constraint(equalToConstant: 240),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
