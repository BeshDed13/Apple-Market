//
//  SupportMessageCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import UIKit

final class SupportMessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SupportMessageCell"
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = nil
    }
    
    func configure(with message: SupportMessage) {
        
        messageLabel.text = message.text
        
        switch message.sender {
            
        case .user:
            messageContainerView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            
        case .support:
            messageContainerView.backgroundColor = UIColor.systemGray6
            messageLabel.textColor = .label
            
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = DesignSystem.Colors.primary
        selectionStyle = .none
        
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        leadingConstraint = messageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        
        trailingConstraint = messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            messageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            messageContainerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -14)
        ])
    }
}
