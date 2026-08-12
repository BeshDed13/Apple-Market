//
//  ProductViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 09.08.2026.
//

import Foundation

struct AttributeOption {
    let value: String
    let isSelected: Bool
    let isAvailable: Bool
}

protocol ProductViewModelProtocol: AnyObject {

    var product: Product? { get }
    var variants: [ProductVariant] { get }
    var selectedVariant: ProductVariant? { get }

    var selectedAttributes: [String: String] { get }
    var isFavorite: Bool { get }

    var onProductUpdated: (() -> Void)? { get set }
    var onVariantSelected: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onFavoriteUpdated: (() -> Void)? { get set }

    func loadProduct()
    func selectAttribute(type: String, value: String)
    func attributeOptions(for type: String) -> [AttributeOption]
    
    var cartQuantity: Int { get }
    var onCartUpdated: (() -> Void)? { get set }
    var onAuthRequired: (() -> Void)? { get set }
    
    func increaseCartQuantity()
    func decreaseCartQuantity()
    func toggleFavorite()
}

final class ProductViewModel: ProductViewModelProtocol {

    var onProductUpdated: (() -> Void)?
    var onVariantSelected: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onCartUpdated: (() -> Void)?
    var onAuthRequired: (() -> Void)?
    var onFavoriteUpdated: (() -> Void)?

    private(set) var cartQuantity: Int = 0
    private(set) var isFavorite: Bool = false

    private let catalogService: CatalogServiceProtocol
    private let productId: String
    private let cartService: CartServiceProtocol
    private let authService: AuthServiceProtocol
    private let favoritesService: FavoritesServiceProtocol

    private(set) var product: Product?
    private(set) var variants: [ProductVariant] = []
    private(set) var selectedVariant: ProductVariant?
    private(set) var selectedAttributes: [String: String] = [:]

    init(
        catalogService: CatalogServiceProtocol,
        productId: String,
        cartService: CartServiceProtocol,
        authService: AuthServiceProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.catalogService = catalogService
        self.productId = productId
        self.cartService = cartService
        self.authService = authService
        self.favoritesService = favoritesService
    }

    func loadProduct() {

        isFavorite = favoritesService.isFavorite(
            productID: productId
        )

        catalogService.fetchProduct(id: productId) { [weak self] result in

            DispatchQueue.main.async {
                switch result {

                case .success(let product):
                    self?.product = product
                    self?.loadVariants()

                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    private func loadVariants() {

        catalogService.fetchVariants(productId: productId) { [weak self] result in

            DispatchQueue.main.async {
                switch result {

                case .success(let variants):

                    self?.variants = variants

                    if let firstVariant = variants.first {
                        self?.selectedVariant = firstVariant
                        self?.selectedAttributes = firstVariant.attributes
                    }
                    
                    self?.loadCartQuantity()
                    self?.onProductUpdated?()

                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    func selectAttribute(
        type: String,
        value: String
    ) {
        selectedAttributes[type] = value

        selectedVariant = variants.first { variant in
            variant.attributes.allSatisfy { key, value in
                selectedAttributes[key] == value
            }
        }

        onVariantSelected?()

        loadCartQuantity()
    }
    
    private func loadCartQuantity() {

        guard case .authorized = authService.authState else {
            cartQuantity = 0
            onCartUpdated?()
            return
        }

        guard let variantId = selectedVariant?.id else {
            cartQuantity = 0
            onCartUpdated?()
            return
        }

        cartService.fetchQuantity(
            variantId: variantId
        ) { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success(let quantity):
                    self?.cartQuantity = quantity
                    self?.onCartUpdated?()

                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    func attributeOptions(
        for type: String
    ) -> [AttributeOption] {

        let values = Set(
            variants.compactMap {
                $0.attributes[type]
            }
        )

        return values
            .sorted()
            .map { value in

                let isSelected =
                    selectedAttributes[type] == value

                let isAvailable = variants.contains { variant in

                    guard variant.attributes[type] == value else {
                        return false
                    }

                    return selectedAttributes.allSatisfy {
                        key, selectedValue in

                        if key == type {
                            return true
                        }

                        return variant.attributes[key] == selectedValue
                    }
                }

                return AttributeOption(
                    value: value,
                    isSelected: isSelected,
                    isAvailable: isAvailable
                )
            }
    }
    
    func increaseCartQuantity() {

        guard case .authorized = authService.authState else {
            onAuthRequired?()
            return
        }

        guard let variant = selectedVariant else {
            return
        }

        guard cartQuantity < variant.stock else {
            return
        }

        if cartQuantity == 0 {

            cartService.addToCart(
                productId: productId,
                variant: variant
            ) { [weak self] result in

                DispatchQueue.main.async {
                    switch result {

                    case .success:
                        self?.loadCartQuantity()

                    case .failure(let error):
                        self?.onError?(error)
                    }
                }
            }

        } else {

            cartService.increaseQuantity(
                variant: variant
            ) { [weak self] result in

                DispatchQueue.main.async {
                    switch result {

                    case .success:
                        self?.loadCartQuantity()

                    case .failure(let error):
                        self?.onError?(error)
                    }
                }
            }
        }
    }
    
    func decreaseCartQuantity() {

        guard case .authorized = authService.authState else {
            onAuthRequired?()
            return
        }

        guard let variantId = selectedVariant?.id else {
            return
        }

        guard cartQuantity > 0 else {
            return
        }

        cartService.decreaseQuantity(
            variantId: variantId
        ) { [weak self] result in

            DispatchQueue.main.async {
                switch result {

                case .success:
                    self?.loadCartQuantity()

                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func toggleFavorite() {
        isFavorite = favoritesService.toggle(
            productID: productId
        )

        onFavoriteUpdated?()
    }
}
