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

    var onProductUpdated: (() -> Void)? { get set }
    var onVariantSelected: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }

    func loadProduct()
    func selectAttribute(type: String, value: String)
    func attributeOptions(for type: String) -> [AttributeOption]
}

final class ProductViewModel: ProductViewModelProtocol {

    var onProductUpdated: (() -> Void)?
    var onVariantSelected: (() -> Void)?
    var onError: ((Error) -> Void)?

    private let catalogService: CatalogServiceProtocol
    private let productId: String

    private(set) var product: Product?
    private(set) var variants: [ProductVariant] = []
    private(set) var selectedVariant: ProductVariant?
    private(set) var selectedAttributes: [String: String] = [:]

    init(
        catalogService: CatalogServiceProtocol,
        productId: String
    ) {
        self.catalogService = catalogService
        self.productId = productId
    }

    func loadProduct() {

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
}
