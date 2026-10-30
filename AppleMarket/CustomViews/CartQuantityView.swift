//
//  CartQuantityView.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import UIKit

final class CartQuantityView: UIView {
    
    // MARK: - Properties

    var onMinusTapped: (() -> Void)?
    var onPlusTapped: (() -> Void)?

    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("−", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI

    private func setupUI() {

        backgroundColor = .systemBlue
        layer.cornerRadius = DesignSystem.Radius.buttonRadius

        addSubview(minusButton)
        addSubview(quantityLabel)
        addSubview(plusButton)

        NSLayoutConstraint.activate([
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            quantityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Actions

    private func setupActions() {

        minusButton.addAction(
            UIAction { [weak self] _ in
                self?.onMinusTapped?()
            },
            for: .touchUpInside
        )

        plusButton.addAction(
            UIAction { [weak self] _ in
                self?.onPlusTapped?()
            },
            for: .touchUpInside
        )
    }
    
    // MARK: - Configure

    func configure(
        quantity: Int,
        canIncrease: Bool
    ) {

        quantityLabel.text = "\(quantity)"
        plusButton.isEnabled = canIncrease
    }
}
