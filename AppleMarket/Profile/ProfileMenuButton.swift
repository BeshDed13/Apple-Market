//
//  ProfileMenuButton.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class ProfileMenuButton: UIButton {
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.plain()
        
        configuration.title = title
        configuration.image = image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        
        configuration.baseForegroundColor = DesignSystem.Colors.mainText
        
        self.configuration = configuration
        
        contentHorizontalAlignment = .leading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
