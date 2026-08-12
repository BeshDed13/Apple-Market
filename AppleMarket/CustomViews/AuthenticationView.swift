//
//  AuthenticationView.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 21.07.2026.
//

import UIKit

final class AuthenticationView: UIView {
    
    var onLoginTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    
    private let cardView = CardView()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = DesignSystem.Fonts.body
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let loginButton = LoginButton()
    private let signUpButton = SignUpButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setupUI() {
        addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(loginButton)
        cardView.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -32),
            
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )
        
        signUpButton.addTarget(
            self,
            action: #selector(signUpTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func loginTapped() {
        onLoginTapped?()
    }
    
    @objc private func signUpTapped() {
        onSignUpTapped?()
    }
}
