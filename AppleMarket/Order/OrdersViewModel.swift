//
//  OrdersViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import Foundation

protocol OrdersViewModelProtocol: AnyObject {
    
    var orders: [Order] { get }
    
    var onOrdersUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadOrders()
}

final class OrdersViewModel: OrdersViewModelProtocol {
    
    var onOrdersUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private(set) var orders: [Order] = []
    
    private let orderService: OrderServiceProtocol
    private let userId: String
    
    init(
        orderService: OrderServiceProtocol,
        userId: String
    ) {
        self.orderService = orderService
        self.userId = userId
    }
    
    func loadOrders() {
        
        orderService.fetchOrders(
            userId: userId
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                guard let self else {
                    return
                }
                
                switch result {
                    
                case .success(let orders):
                    self.orders = orders
                    self.onOrdersUpdated?()
                    
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
}
