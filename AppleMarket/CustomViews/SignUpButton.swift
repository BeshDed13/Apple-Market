//
//  SignUpButton.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 21.07.2026.
//

import UIKit

final class SignUpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        backgroundColor = .systemGreen
        layer.cornerRadius = DesignSystem.Radius.buttonRadius
        setTitle("Зарегистрироваться", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = DesignSystem.Fonts.body
        translatesAutoresizingMaskIntoConstraints = false
    }
}

