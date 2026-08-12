//
//  CatalogCategoryCell.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.07.2026.
//

import UIKit

final class CatalogCategoryCell: UICollectionViewCell {

    static let identifier = "CatalogCategoryCell"

    private let imageView = UIImageView()

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {

        backgroundColor = DesignSystem.Colors.primary
        layer.cornerCurve = .continuous

        layer.cornerRadius = DesignSystem.Radius.cellRadius
        layer.shadowColor = DesignSystem.Shadow.color
        layer.shadowOpacity = DesignSystem.Shadow.opacity
        layer.shadowRadius = DesignSystem.Shadow.radius
        layer.shadowOffset = DesignSystem.Shadow.offset

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    func configure(with category: CatalogCategory) {
        titleLabel.text = category.title
        imageView.image = UIImage(named: category.imageName)
    }
}
