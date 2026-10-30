//
//  AvatarCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.07.2026.
//

import UIKit

final class AvatarCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        layer.cornerRadius = DesignSystem.Radius.cellRadius
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Configure
    
    func configure(with avatar: Avatar) {
        imageView.image = avatar.image
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected
            ? UIColor.systemGreen.cgColor
            : UIColor.clear.cgColor
        }
    }
}

