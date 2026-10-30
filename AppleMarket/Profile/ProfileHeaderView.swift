//
//  ProfileHeaderView.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Properties
    
    private let cardView = CardView()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystem.Fonts.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(avatarId: String, name: String) {
        avatarImageView.image = UIImage(named: avatarId)
        nameLabel.text = name
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        
        avatarImageView.layer.cornerRadius = DesignSystem.Radius.avatarRadius
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: DesignSystem.Sizes.avatar),
            avatarImageView.heightAnchor.constraint(equalToConstant: DesignSystem.Sizes.avatar),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16
            )
        ])
    }
}
