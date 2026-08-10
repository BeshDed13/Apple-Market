//
//  AttributeButton.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 10.08.2026.
//

import UIKit

final class AttributeButton: UIButton {
    
    enum Style {
        case text
        case color(UIColor)
    }
    
    func configure(
        title: String?,
        style: Style,
        isSelected: Bool,
        isAvailable: Bool
    ) {
        layer.cornerRadius = DesignSystem.Radius.medium
        layer.borderWidth = 0.5
        
        alpha = isAvailable ? 1 : 0.5
        isUserInteractionEnabled = isAvailable
        
        if isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
        }
        
        switch style {
        case .text:
            setTitle(title, for: .normal)
            backgroundColor = DesignSystem.Colors.primary
            setTitleColor(.label, for: .normal)
            
            contentEdgeInsets = UIEdgeInsets(
                top: 6,
                left: 12,
                bottom: 6,
                right: 12
            )
        case .color(let color):
            setTitle(nil, for: .normal)
            backgroundColor = color
        }
    }
}
