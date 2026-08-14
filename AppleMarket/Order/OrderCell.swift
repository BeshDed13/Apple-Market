//
//  OrderCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import UIKit

final class OrderCell: UITableViewCell {
    
    static let identifier = "OrderCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.primary
        view.layer.cornerRadius = DesignSystem.Radius.cellRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14,
            weight: .medium
        )
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        orderNumberLabel.text = nil
        dateLabel.text = nil
        itemsLabel.text = nil
        priceLabel.text = nil
        statusLabel.text = nil
    }
    
    func configure(with order: Order) {
        
        if let orderId = order.id {
            orderNumberLabel.text = "Заказ №\(orderId.prefix(8))"
        } else {
            orderNumberLabel.text = "Заказ"
        }
        
        dateLabel.text = formattedDate(order.createdAt)
        
        let itemsCount = order.items.reduce(0) {
            $0 + $1.quantity
        }
        
        itemsLabel.text = "\(itemsCount) \(itemsWord(for: itemsCount))"
        
        priceLabel.text = "\(order.totalPrice) ₽"
        
        statusLabel.text = statusTitle(for: order.status)
        statusLabel.textColor = statusColor(for: order.status)
    }
    
    private func setupUI() {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(orderNumberLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(itemsLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(statusLabel)
        
        layer.cornerRadius = DesignSystem.Radius.cellRadius
        
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 6
            ),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -6
            ),
            
            orderNumberLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 14
            ),
            orderNumberLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 16
            ),
            
            statusLabel.centerYAnchor.constraint(
                equalTo: orderNumberLabel.centerYAnchor
            ),
            statusLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: orderNumberLabel.trailingAnchor,
                constant: 8
            ),
            statusLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -16
            ),
            
            dateLabel.topAnchor.constraint(
                equalTo: orderNumberLabel.bottomAnchor,
                constant: 5
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: orderNumberLabel.leadingAnchor
            ),
            
            itemsLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 4
            ),
            itemsLabel.leadingAnchor.constraint(
                equalTo: orderNumberLabel.leadingAnchor
            ),
            
            priceLabel.topAnchor.constraint(
                equalTo: itemsLabel.bottomAnchor,
                constant: 10
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: orderNumberLabel.leadingAnchor
            ),
            priceLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -14
            )
        ])
    }
    
    private func formattedDate(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy, HH:mm"
        
        return formatter.string(from: date)
    }
    
    private func itemsWord(for count: Int) -> String {
        
        let lastTwo = count % 100
        let last = count % 10
        
        if (11...14).contains(lastTwo) {
            return "товаров"
        }
        
        switch last {
        case 1:
            return "товар"
        case 2...4:
            return "товара"
        default:
            return "товаров"
        }
    }
    
    private func statusTitle(for status: OrderStatus) -> String {
        
        switch status {
        case .placed:
            return "Создан"
            
        case .readyForPickup:
            return "Готов к получению"
            
        case .completed:
            return "Выполнен"
            
        case .cancelled:
            return "Отменён"
        }
    }
    
    private func statusColor(for status: OrderStatus) -> UIColor {
        
        switch status {
        case .placed:
            return .systemBlue
            
        case .readyForPickup:
            return .systemOrange
            
        case .completed:
            return .systemGreen
            
        case .cancelled:
            return .systemRed
        }
    }
}
