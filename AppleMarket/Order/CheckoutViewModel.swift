//
//  CheckoutViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import Foundation

protocol CheckoutViewModelProtocol: AnyObject {
    
    var userName: String { get }
    var userEmail: String { get }
    
    var stores: [Store] { get }
    var selectedStore: Store? { get }
    
    var onStoresUpdated: (() -> Void)? { get set }
    var onStoreSelected: (() -> Void)? { get set }
    var onOrderCreated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadStores()
    func selectStore(at index: Int)
    func createOrder()
}

final class CheckoutViewModel: CheckoutViewModelProtocol {
    
    var onStoresUpdated: (() -> Void)?
    var onStoreSelected: (() -> Void)?
    var onOrderCreated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let storeService: StoreServiceProtocol
    private let orderService: OrderServiceProtocol
    private let cartService: CartServiceProtocol
    private let notificationService: NotificationServiceProtocol
    private let user: UserModel
    
    private(set) var stores: [Store] = []
    private(set) var selectedStore: Store?
    
    private let cartProducts: [CartProduct]
    
    var userName: String {
        user.name
    }
    
    var userEmail: String {
        user.email
    }
    
    init(
        storeService: StoreServiceProtocol,
        orderService: OrderServiceProtocol,
        cartService: CartServiceProtocol,
        notificationService: NotificationServiceProtocol,
        user: UserModel,
        cartProducts: [CartProduct]
    ) {
        self.storeService = storeService
        self.orderService = orderService
        self.cartService = cartService
        self.notificationService = notificationService
        self.user = user
        self.cartProducts = cartProducts
    }
    
    func loadStores() {
        storeService.fetchStores { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let stores):
                    self?.stores = stores
                    self?.onStoresUpdated?()
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func selectStore(at index: Int) {
        
        guard stores.indices.contains(index) else {
            return
        }
        
        selectedStore = stores[index]
        onStoreSelected?()
    }
    
    func createOrder() {
        
        guard let selectedStore else {
            return
        }
        
        let items = cartProducts.compactMap { cartProduct -> OrderItem? in
            
            guard let variantId = cartProduct.variant.id else {
                return nil
            }
            
            return OrderItem(
                productId: cartProduct.product.id ?? "",
                variantId: variantId,
                name: cartProduct.product.name,
                imageURL: cartProduct.product.baseImage,
                price: cartProduct.variant.price,
                quantity: cartProduct.quantity,
                attributes: cartProduct.variant.attributes
            )
        }
        
        let totalPrice = cartProducts.reduce(0) {
            $0 + $1.totalPrice
        }
        
        orderService.createOrder(
            store: selectedStore,
            items: items,
            totalPrice: totalPrice,
            userId: user.id
        ) { [weak self] result in
            
            guard let self else {
                return
            }
            
            switch result {
                
            case .success(let order):

                self.notificationService.createOrderNotification(
                    order: order
                ) { [weak self] result in
                    
                    guard let self else {
                        return
                    }
                    
                    if case .failure(let error) = result {
                        print("Failed to create notification:", error)
                    }
                    
                    self.cartService.clearCart { [weak self] result in
                        
                        guard let self else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            switch result {
                                
                            case .success:
                                self.onOrderCreated?()
                                
                            case .failure(let error):
                                self.onError?(error)
                            }
                        }
                    }
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }
}
