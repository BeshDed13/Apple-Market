//
//  ProfileMenuView.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class ProfileMenuView: UIView {
    
    // MARK: - Properties
    
    var onOrdersTapped: (() -> Void)?
    var onSettingsTapped: (() -> Void)?
    var onSupportTapped: (() -> Void)?
    
    private let cardView = CardView()
    
    private let ordersButton = ProfileMenuButton(
        title: "Заказы",
        image: UIImage(systemName: "bag")
    )
    
    private let settingsButton = ProfileMenuButton(
        title: "Настройки",
        image: UIImage(systemName: "gearshape")
    )
    
    private let supportButton = ProfileMenuButton(
        title: "Поддержка",
        image: UIImage(systemName: "message")
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(ordersButton)
        cardView.addSubview(settingsButton)
        cardView.addSubview(supportButton)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ordersButton.topAnchor.constraint(equalTo: cardView.topAnchor),
            ordersButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            ordersButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            ordersButton.heightAnchor.constraint(equalToConstant: 100),
            
            settingsButton.topAnchor.constraint(equalTo: ordersButton.bottomAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            settingsButton.heightAnchor.constraint(equalToConstant: 100),
            
            supportButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor),
            supportButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            supportButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            supportButton.heightAnchor.constraint(equalToConstant: 100),
            supportButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        ordersButton.addTarget(
            self,
            action: #selector(ordersTapped),
            for: .touchUpInside
        )
        
        settingsButton.addTarget(
            self,
            action: #selector(settingsTapped),
            for: .touchUpInside
        )
        
        supportButton.addTarget(
            self,
            action: #selector(supportTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func ordersTapped() {
        onOrdersTapped?()
    }
    
    @objc private func settingsTapped() {
        onSettingsTapped?()
    }
    
    @objc private func supportTapped() {
        onSupportTapped?()
    }
}
