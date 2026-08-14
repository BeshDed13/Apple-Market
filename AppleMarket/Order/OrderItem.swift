//
//  OrderItem.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import Foundation

struct OrderItem: Codable {
    let productId: String
    let variantId: String
    let name: String
    let imageURL: String
    let price: Int
    let quantity: Int
    let attributes: [String: String]
}
