//
//  OrderService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import FirebaseFirestore

protocol OrderServiceProtocol {
    
    func createOrder(
        store: Store,
        items: [OrderItem],
        totalPrice: Int,
        userId: String,
        completion: @escaping (Result<Order, Error>) -> Void
    )
    
    func fetchOrders(
        userId: String,
        completion: @escaping (Result<[Order], Error>) -> Void
    )
}

final class OrderService: OrderServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func createOrder(
        store: Store,
        items: [OrderItem],
        totalPrice: Int,
        userId: String,
        completion: @escaping (Result<Order, Error>) -> Void
    ) {
        
        let orderReference = db
            .collection("users")
            .document(userId)
            .collection("orders")
            .document()
        
        let order = Order(
            id: orderReference.documentID,
            userId: userId,
            items: items,
            storeId: store.id ?? "",
            status: .placed,
            totalPrice: totalPrice,
            createdAt: Date()
        )
        
        do {
            try orderReference.setData(from: order) { error in
                
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success((order)))
                }
            }
            
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchOrders(userId: String, completion: @escaping (Result<[Order], Error>) -> Void) {
        db
            .collection("users")
            .document(userId)
            .collection("orders")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                do {
                    let orders = try documents.map {
                        try $0.data(as: Order.self)
                    }
                    
                    completion(.success(orders))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
