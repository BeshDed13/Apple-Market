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
        addSubview(titleLabel)
        addSubview(loginButton)
        addSubview(signUpButton)
        
        layer.cornerRadius = DesignSystem.Radius.xlarge
        layer.borderWidth = 2
        layer.borderColor = UIColor.separator.cgColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        onLoginTapped?()
    }
    
    @objc private func signUpTapped() {
        onSignUpTapped?()
    }
}
