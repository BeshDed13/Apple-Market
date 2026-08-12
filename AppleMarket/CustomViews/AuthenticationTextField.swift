//
//  AuthenticationTextField.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.07.2026.
//

import UIKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = DesignSystem.Radius.buttonRadius
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        clipsToBounds = true
        autocorrectionType = .no
        spellCheckingType = .no
        returnKeyType = .next
    }
}
