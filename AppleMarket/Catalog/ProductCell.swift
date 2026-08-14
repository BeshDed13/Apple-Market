//
//  ProductCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 08.08.2026.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    var onFavoriteTapped: ((String) -> Bool)?
    
    private var productID: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .selected)
        button.tintColor = .systemGray4
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        
        productID = nil
        favoriteButton.isSelected = false
        favoriteButton.tintColor = .systemGray4
    }
    
    func configure(
        with product: Product,
        isFavorite: Bool
    ) {
        titleLabel.text = product.name
        priceLabel.text = "От \(product.minPrice)"
        productID = product.id
        
        favoriteButton.isSelected = isFavorite
        favoriteButton.tintColor = isFavorite
            ? .systemRed
            : .systemGray4
        
        loadImage(from: product.baseImage)
    }
    
    private func setupUI() {
        backgroundColor = DesignSystem.Colors.primary
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(favoriteButton)
        
        layer.cornerRadius = DesignSystem.Radius.cellRadius
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let data,
                let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
    
    @objc private func favoriteButtonTapped() {
        guard let productID else {
            return
        }

        let isFavorite = onFavoriteTapped?(productID) ?? false

        favoriteButton.isSelected = isFavorite
        favoriteButton.tintColor = isFavorite
            ? .systemRed
            : .systemGray4
    }
}
