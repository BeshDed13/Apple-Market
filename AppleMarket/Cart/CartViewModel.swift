//
//  CartViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 31.07.2026.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    
    var authState: AuthState { get }
    var cartProducts: [CartProduct] { get }
    var totalPrice: Int { get }
    
    var onStateChanged: (() -> Void)? { get set }
    var onCartUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadCart()
    func increaseQuantity(at index: Int)
    func decreaseQuantity(at index: Int)
    func removeItem(at index: Int)
    
    func makeOrderItems() -> [OrderItem]
}

@MainActor
final class CartViewModel: CartViewModelProtocol {
    
    var onStateChanged: (() -> Void)?
    var onCartUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private(set) var authState: AuthState = .loading {
        didSet {
            onStateChanged?()
        }
    }
    
    private(set) var cartProducts: [CartProduct] = [] {
        didSet {
            onCartUpdated?()
        }
    }
    
    var totalPrice: Int {
        cartProducts.reduce(0) {
            $0 + $1.totalPrice
        }
    }
    
    private let authService: AuthServiceProtocol
    private let cartService: CartServiceProtocol
    private let catalogService: CatalogServiceProtocol
    
    init(
        authService: AuthServiceProtocol,
        cartService: CartServiceProtocol,
        catalogService: CatalogServiceProtocol
    ) {
        self.authService = authService
        self.cartService = cartService
        self.catalogService = catalogService
    }
    
    func loadCart() {
        
        guard case .authorized = authService.authState else {
            cartProducts = []
            authState = .guest
            return
        }
        
        authState = .loading
        
        cartService.fetchCart { [weak self] result in
            
            guard let self else { return }
            
            Task { @MainActor in
                
                switch result {
                    
                case .success(let cartItems):
                    self.loadProducts(for: cartItems)
                    
                case .failure(let error):
                    self.authState = .guest
                    self.onError?(error)
                }
            }
        }
    }
    
    private func loadProducts(for cartItems: [CartItem]) {
        
        guard !cartItems.isEmpty else {
            cartProducts = []
            
            if case .authorized(let user) = authService.authState {
                authState = .authorized(user)
            }
            
            return
        }
        
        var result: [CartProduct] = []
        let group = DispatchGroup()
        
        for item in cartItems {
            
            group.enter()
            
            catalogService.fetchProduct(id: item.productId) { [weak self] productResult in
                
                switch productResult {
                    
                case .success(let product):
                    
                    self?.catalogService.fetchVariants(
                        productId: item.productId
                    ) { variantResult in
                        
                        switch variantResult {
                            
                        case .success(let variants):
                            
                            guard let variant = variants.first(
                                where: { $0.id == item.id }
                            ) else {
                                group.leave()
                                return
                            }
                            
                            result.append(
                                CartProduct(
                                    product: product,
                                    variant: variant,
                                    quantity: item.quantity
                                )
                            )
                            
                        case .failure(let error):
                            self?.onError?(error)
                        }
                        
                        group.leave()
                    }
                    
                case .failure(let error):
                    self?.onError?(error)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let self else { return }
            
            self.cartProducts = result
            
            if case .authorized(let user) = self.authService.authState {
                self.authState = .authorized(user)
            }
        }
    }
    
    func increaseQuantity(at index: Int) {
        
        guard cartProducts.indices.contains(index) else {
            return
        }
        
        let item = cartProducts[index]
        
        guard item.quantity < item.variant.stock else {
            return
        }
        
        cartService.increaseQuantity(
            variant: item.variant
        ) { [weak self] result in
            
            Task { @MainActor in
                
                switch result {
                    
                case .success:
                    self?.cartProducts[index].quantity += 1
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func decreaseQuantity(at index: Int) {
        
        guard cartProducts.indices.contains(index) else {
            return
        }
        
        let item = cartProducts[index]
        
        guard item.quantity > 1 else {
            return
        }
        
        cartService.decreaseQuantity(
            variantId: item.variant.id!
        ) { [weak self] result in
            
            Task { @MainActor in
                
                switch result {
                    
                case .success:
                    self?.cartProducts[index].quantity -= 1
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func removeItem(at index: Int) {
        
        guard cartProducts.indices.contains(index) else {
            return
        }
        
        guard let variantId = cartProducts[index].variant.id else {
            return
        }
        
        cartService.removeFromCart(
            variantId: variantId
        ) { [weak self] result in
            
            Task { @MainActor in
                guard let self else { return }
                switch result {
                    
                case .success:
                    self.cartProducts.remove(at: index)
                    
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    
    func makeOrderItems() -> [OrderItem] {
        
        cartProducts.compactMap { item in
            
            guard let variantId = item.variant.id else {
                return nil
            }
            
            return OrderItem(
                productId: item.product.id ?? "",
                variantId: variantId,
                name: item.product.name,
                imageURL: item.product.baseImage,
                price: item.variant.price,
                quantity: item.quantity,
                attributes: item.variant.attributes
            )
        }
    }
}
