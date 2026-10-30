//
//  StoreCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import UIKit

final class StoreCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StoreCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .medium
        )
        label.textColor = DesignSystem.Colors.secondaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(
        with store: Store,
        isSelected: Bool
    ) {
        nameLabel.text = store.name
        
        checkImageView.image = UIImage(
            systemName: isSelected
                ? "checkmark.circle.fill"
                : "circle"
        )
        
        checkImageView.tintColor = isSelected
            ? .systemBlue
            : .systemGray4
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkImageView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: checkImageView.leadingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
