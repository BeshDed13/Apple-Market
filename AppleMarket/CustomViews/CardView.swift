//
//  CardView.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = DesignSystem.Colors.primary
        
        layer.cornerRadius = DesignSystem.Radius.cellRadius
        layer.cornerCurve = .continuous
        
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: DesignSystem.Radius.cellRadius
        ).cgPath
    }
}
