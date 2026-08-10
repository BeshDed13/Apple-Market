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
    }
    
    enum Fonts {
        static let title = UIFont.preferredFont(forTextStyle: .title1)
        static let body = UIFont.preferredFont(forTextStyle: .body)
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
    }
    
    enum Radius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 25
        static let cellRadius: CGFloat = 20
    }
    
    
}
