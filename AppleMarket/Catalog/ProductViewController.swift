//
//  ProductViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 09.08.2026.
//

import UIKit

final class ProductViewController: UIViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleMarketLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var onLoginTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?

    private let viewModel: ProductViewModelProtocol
    private let imageLoader: ImageLoaderProtocol

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attributesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = DesignSystem.Radius.xlarge
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cartQuantityView: CartQuantityView = {
        let view = CartQuantityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    init(
        viewModel: ProductViewModelProtocol,
        imageLoader: ImageLoaderProtocol
    ) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        setupActions()
        bindViewModel()

        viewModel.loadProduct()
    }
    
    private func setupUI() {
        view.backgroundColor = DesignSystem.Colors.primary

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(attributesStackView)
        view.addSubview(priceLabel)
        view.addSubview(addToCartButton)
        view.addSubview(cartQuantityView)
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            attributesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            attributesStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            attributesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: attributesStackView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: 16),
            
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.widthAnchor.constraint(equalToConstant: 150),
            
            cartQuantityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cartQuantityView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            cartQuantityView.heightAnchor.constraint(equalToConstant: 50),
            cartQuantityView.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    private func setupActions() {

        addToCartButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.increaseCartQuantity()
            },
            for: .touchUpInside
        )

        cartQuantityView.onMinusTapped = { [weak self] in
            self?.viewModel.decreaseCartQuantity()
        }

        cartQuantityView.onPlusTapped = { [weak self] in
            self?.viewModel.increaseCartQuantity()
        }
    }
    
    private func bindViewModel() {

        viewModel.onProductUpdated = { [weak self] in
            self?.updateUI()
        }

        viewModel.onVariantSelected = { [weak self] in
            self?.updateSelectedVariant()
        }

        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
        
        viewModel.onCartUpdated = { [weak self] in
            self?.updateCartButton()
        }
        
        viewModel.onAuthRequired = { [weak self] in
            self?.showAuthAlert()
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "ОК",
                style: .default
            )
        )

        present(alert, animated: true)
    }
    
    private func showAuthAlert() {

        let alert = UIAlertController(
            title: "Требуется авторизация",
            message: "Чтобы добавить товар в корзину, войдите в аккаунт или зарегистрируйтесь.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Войти",
                style: .default
            ) { [weak self] _ in

                self?.onLoginTapped?()
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Регистрация",
                style: .default
            ) { [weak self] _ in

                self?.onSignUpTapped?()
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel
            )
        )

        present(alert, animated: true)
    }
    
    private func updateCartButton() {

        guard let variant = viewModel.selectedVariant else {
            addToCartButton.isHidden = false
            cartQuantityView.isHidden = true
            addToCartButton.isEnabled = false
            return
        }

        let quantity = viewModel.cartQuantity

        if quantity == 0 {

            addToCartButton.isHidden = false
            cartQuantityView.isHidden = true

            addToCartButton.isEnabled = variant.stock > 0

        } else {

            addToCartButton.isHidden = true
            cartQuantityView.isHidden = false

            cartQuantityView.configure(
                quantity: quantity,
                canIncrease: quantity < variant.stock
            )
        }
    }
    
    private func updateUI() {

        guard let product = viewModel.product else {
            return
        }

        titleLabel.text = product.name
        descriptionLabel.text = product.description

        updateAttributes()
        updateImage(urlString: product.baseImage)
        updateSelectedVariant()
    }
    
    private func updateImage(urlString: String?) {

        guard let urlString, !urlString.isEmpty else {
            imageView.image = nil
            return
        }

        imageLoader.loadImage(from: urlString) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    private func updateSelectedVariant() {

        guard let variant = viewModel.selectedVariant else {
            return
        }

        priceLabel.text = "\(variant.price) ₽"

        if let imageURL = variant.images.first {
            updateImage(urlString: imageURL)
        }

        updateAttributes()
    }
    
    private func updateAttributes() {
        
        attributesStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let attributeTypes = Set(
            viewModel.variants.flatMap {
                $0.attributes.keys
            }
        )
        
        for type in attributeTypes.sorted() {
            
            let section = makeAttributeSection(
                type: type
            )
            
            attributesStackView.addArrangedSubview(section)
        }
    }
    
    private func makeAttributeSection(type: String) -> UIView {
        
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = attributeTitle(for: type)
        titleLabel.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let options = viewModel.attributeOptions(for: type)
        
        for option in options {
            
            let button = AttributeButton()
            
            let style: AttributeButton.Style
            
            if type == "color" {
                style = .color(
                    color(for: option.value)
                )
            } else {
                style = .text
            }
            
            button.configure(
                title: option.value,
                style: style,
                isSelected: option.isSelected,
                isAvailable: option.isAvailable
            )
            
            button.addAction(
                UIAction { [weak self] _ in
                    self?.viewModel.selectAttribute(
                        type: type,
                        value: option.value
                    )
                },
                for: .touchUpInside
            )
            
            buttonsStack.addArrangedSubview(button)
        }
        
        container.addSubview(titleLabel)
        container.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: container.topAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: container.leadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: container.trailingAnchor
            ),
            
            buttonsStack.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),
            buttonsStack.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 8
            ),
            buttonsStack.trailingAnchor.constraint(
                lessThanOrEqualTo: container.trailingAnchor,
                constant: 8
            ),
            buttonsStack.bottomAnchor.constraint(
                equalTo: container.bottomAnchor
            )
        ])
        
        return container
    }
    
    private func color(for value: String) -> UIColor {
        switch value.lowercased() {
        case "black":
            return .black
        case "white":
            return .white
        case "blue":
            return .systemBlue
        case "silver":
            return .systemGray4
        case "gold":
            return .systemYellow
        case "red":
            return .systemRed
        case "green":
            return .systemGreen
        case "purple":
            return .systemPurple
        case "pink":
            return .systemPink
        default:
            return .systemGray
        }
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

