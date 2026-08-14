//
//  NotificationCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import UIKit

final class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.primary
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "bell.fill"
        )
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14
        )
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 12
        )
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unreadView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        titleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
        
        unreadView.isHidden = true
    }
    
    func configure(
        with notification: AppNotification
    ) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        dateLabel.text = formattedDate(
            notification.createdAt
        )
        
        unreadView.isHidden = notification.isRead
        
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: notification.isRead ? .regular : .semibold
        )
    }
    
    private func setupUI() {
        backgroundColor = DesignSystem.Colors.primary
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(unreadView)
        
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
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -6
            ),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            
            iconView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 14
            ),
            iconView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 16
            ),
            iconView.widthAnchor.constraint(
                equalToConstant: 24
            ),
            iconView.heightAnchor.constraint(
                equalToConstant: 24
            ),
            
            unreadView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 10
            ),
            unreadView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -10
            ),
            unreadView.widthAnchor.constraint(
                equalToConstant: 8
            ),
            unreadView.heightAnchor.constraint(
                equalToConstant: 8
            ),
            
            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 12
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: 12
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: dateLabel.leadingAnchor,
                constant: -8
            ),
            
            dateLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 12
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -12
            ),
            
            messageLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 4
            ),
            messageLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            messageLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -12
            ),
            messageLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: containerView.bottomAnchor,
                constant: -10
            )
        ])
    }
    
    private func formattedDate(
        _ date: Date
    ) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        return formatter.string(from: date)
    }
}
