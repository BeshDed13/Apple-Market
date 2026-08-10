//
//  CategoryViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.08.2026.
//

import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    
    var products: [Product] { get }
    
    var onProductsUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadProducts()
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let catalogService: CatalogServiceProtocol
    private let categoryId: String
    
    private(set) var products: [Product] = []
    
    init(catalogService: CatalogServiceProtocol, categoryId: String) {
        self.catalogService = catalogService
        self.categoryId = categoryId
    }
    
    func loadProducts() {
        catalogService.fetchProducts(categoryId: categoryId) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.onProductsUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }

}
