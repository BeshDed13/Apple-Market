//
//  NotificationService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

//
//  NotificationService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import FirebaseFirestore

protocol NotificationServiceProtocol {
    
    func createOrderNotification(
        order: Order,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func updateOrderNotification(
        order: Order,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func fetchNotifications(
        userId: String,
        completion: @escaping (Result<[AppNotification], Error>) -> Void
    )
    
    func markAsRead(
        notificationId: String,
        userId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class NotificationService: NotificationServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func createOrderNotification(
        order: Order,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        guard let orderId = order.id else {
            completion(
                .failure(NotificationError.invalidOrderId)
            )
            return
        }
        
        let notification = AppNotification(
            id: orderId,
            type: .order,
            orderId: orderId,
            title: "Заказ",
            message: message(for: order.status),
            createdAt: order.createdAt,
            isRead: false
        )
        
        let reference = db
            .collection("users")
            .document(order.userId)
            .collection("notifications")
            .document(orderId)
        
        do {
            try reference.setData(
                from: notification
            ) { error in
                
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
            
        } catch {
            completion(.failure(error))
        }
    }

    func updateOrderNotification(
        order: Order,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        guard let orderId = order.id else {
            completion(
                .failure(NotificationError.invalidOrderId)
            )
            return
        }
        
        let reference = db
            .collection("users")
            .document(order.userId)
            .collection("notifications")
            .document(orderId)
        
        reference.updateData([
            "message": message(for: order.status),
            "isRead": false
        ]) { error in
            
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchNotifications(
        userId: String,
        completion: @escaping (Result<[AppNotification], Error>) -> Void
    ) {
        
        db
            .collection("users")
            .document(userId)
            .collection("notifications")
            .order(
                by: "createdAt",
                descending: true
            )
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
                    let notifications = try documents.map {
                        try $0.data(as: AppNotification.self)
                    }
                    
                    completion(.success(notifications))
                    
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func markAsRead(
        notificationId: String,
        userId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let reference = db
            .collection("users")
            .document(userId)
            .collection("notifications")
            .document(notificationId)
        
        reference.updateData([
            "isRead": true
        ]) { error in
            
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func message(
        for status: OrderStatus
    ) -> String {
        
        switch status {
        case .placed:
            return "Заказ создан"
            
        case .readyForPickup:
            return "Заказ готов к получению"
            
        case .completed:
            return "Заказ выполнен"
            
        case .cancelled:
            return "Заказ отменён"
        }
    }
}
