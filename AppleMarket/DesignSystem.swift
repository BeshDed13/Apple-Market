//
//  DesignSystem.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 02.07.2026.
//

import UIKit

enum DesignSystem {
    
    enum Colors {
        static let primary = UIColor(named: "MainColor")
        static let secondary = UIColor(named: "ExtraColor")
        static let mainText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
    }
    
    enum Fonts {
        static let title = UIFont.preferredFont(forTextStyle: .title1)
        static let body = UIFont.preferredFont(forTextStyle: .body)
    }
    
    enum Spacing {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
    }
    
    enum Radius {
        static let attributeButtonRadius: CGFloat = 10
        static let buttonRadius: CGFloat = 25
        static let cellRadius: CGFloat = 20
        static let avatarRadius: CGFloat = 35
    }
    
    enum Shadow {
        static let color = UIColor.black.cgColor
        static let opacity: Float = 0.1
        static let radius: CGFloat = 10
        static let offset = CGSize(width: 0, height: 5)
    }
    
    enum Sizes {
        static let avatar: CGFloat = 70
    }
}
