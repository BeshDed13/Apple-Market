//
//  AppNotification.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import FirebaseFirestore

enum NotificationType: String, Codable {
    case order
}

struct AppNotification: Codable {
    @DocumentID var id: String?
    let type: NotificationType
    let orderId: String
    let title: String
    var message: String
    let createdAt: Date
    var isRead: Bool
}

enum NotificationError: LocalizedError {
    
    case invalidOrderId
    
    var errorDescription: String? {
        
        switch self {
        case .invalidOrderId:
            return "Не удалось определить идентификатор заказа."
        }
    }
}
