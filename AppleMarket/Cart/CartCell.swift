//
//  CartCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import UIKit

final class CartCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CartCell"
    
    var onIncreaseTapped: (() -> Void)?
    var onDecreaseTapped: (() -> Void)?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                minusButton,
                quantityLabel,
                plusButton
            ]
        )
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
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
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        titleLabel.text = nil
        attributesLabel.text = nil
        priceLabel.text = nil
        quantityLabel.text = nil
        
        onIncreaseTapped = nil
        onDecreaseTapped = nil
    }
    
    // MARK: - Configure
    
    func configure(
        with item: CartProduct,
        imageLoader: ImageLoaderProtocol
    ) {
        titleLabel.text = item.product.name
        priceLabel.text = "\(item.totalPrice) ₽"
        quantityLabel.text = "\(item.quantity)"
        
        minusButton.isEnabled = item.quantity > 1
        plusButton.isEnabled = item.quantity < item.variant.stock
        
        let attributes = item.variant.attributes
            .sorted { $0.key < $1.key }
            .map {
                "\(attributeTitle(for: $0.key)): \($0.value)"
            }
        
        attributesLabel.text = attributes.joined(separator: "\n")
        
        guard let imageURL = item.variant.images.first else {
            productImageView.image = nil
            return
        }
        
        imageLoader.loadImage(from: imageURL) { [weak self] image in
            self?.productImageView.image = image
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = DesignSystem.Colors.primary
        selectionStyle = .none
        
        contentView.backgroundColor = DesignSystem.Colors.primary
        
        contentView.layer.cornerRadius = DesignSystem.Radius.cellRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = DesignSystem.Radius.cellRadius
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(attributesLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityStack)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            productImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            attributesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            attributesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            attributesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            quantityStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            quantityStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            contentView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        
        minusButton.addTarget(
            self,
            action: #selector(minusTapped),
            for: .touchUpInside
        )
        
        plusButton.addTarget(
            self,
            action: #selector(plusTapped),
            for: .touchUpInside
        )
    }
    
    @objc
    private func minusTapped() {
        onDecreaseTapped?()
    }
    
    @objc
    private func plusTapped() {
        onIncreaseTapped?()
    }
    
    private func attributeTitle(for key: String) -> String {
        switch key {
        case "color":
            return "Цвет"
        case "storage":
            return "Память"
        case "connectivity":
            return "Подключение"
        case "chip":
            return "Процессор"
        case "ram":
            return "Оперативная память"
        case "diagonal":
            return "Диагональ"
        default:
            return key
        }
    }
}
