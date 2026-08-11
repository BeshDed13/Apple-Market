//
//  CartItem.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import Foundation

struct CartItem: Codable, Identifiable {
    let id: String
    let productId: String
    var quantity: Int
}
