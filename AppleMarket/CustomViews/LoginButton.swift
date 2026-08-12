//
//  LoginButton.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 21.07.2026.
//

import UIKit

final class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        backgroundColor = .systemBlue
        layer.cornerRadius = DesignSystem.Radius.buttonRadius
        setTitle("Войти", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = DesignSystem.Fonts.body
        translatesAutoresizingMaskIntoConstraints = false
    }
}
