//
//  Order.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import Foundation
import FirebaseFirestore

enum OrderStatus: String, Codable {
    case placed
    case cancelled
    case readyForPickup
    case completed
}

struct Order: Codable {
    @DocumentID var id: String?
    let userId: String
    let items: [OrderItem]
    let storeId: String
    let status: OrderStatus
    let totalPrice: Int
    let createdAt: Date
}
