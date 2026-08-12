//
//  FavoritesViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import Foundation

protocol FavoritesViewModelProtocol: AnyObject {
    
    var products: [Product] { get }
    
    var onProductsUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadFavorites()
    
    func isFavorite(productID: String) -> Bool
    func toggleFavorite(productID: String) -> Bool
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let favoritesService: FavoritesServiceProtocol
    private let catalogService: CatalogServiceProtocol
    
    private(set) var products: [Product] = []
    
    init(
        favoritesService: FavoritesServiceProtocol,
        catalogService: CatalogServiceProtocol
    ) {
        self.favoritesService = favoritesService
        self.catalogService = catalogService
    }
    
    func loadFavorites() {
        
        let favoriteIDs = favoritesService.fetchFavoriteIDs()
        
        guard !favoriteIDs.isEmpty else {
            products = []
            onProductsUpdated?()
            return
        }
        
        let group = DispatchGroup()
        
        var loadedProducts: [Product] = []
        var firstError: Error?
        
        for productID in favoriteIDs {
            
            group.enter()
            
            catalogService.fetchProduct(id: productID) { result in
                
                switch result {
                    
                case .success(let product):
                    loadedProducts.append(product)
                    
                case .failure(let error):
                    if firstError == nil {
                        firstError = error
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let self else {
                return
            }
            
            if let firstError {
                self.onError?(firstError)
            }
            
            self.products = loadedProducts
            self.onProductsUpdated?()
        }
    }
    
    func isFavorite(productID: String) -> Bool {
        favoritesService.isFavorite(
            productID: productID
        )
    }
    
    @discardableResult
    func toggleFavorite(productID: String) -> Bool {
        
        let isFavorite = favoritesService.toggle(
            productID: productID
        )
        
        return isFavorite
    }
}
