//
//  Product.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 04.07.2026.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: String
    let name: String
    let icon: String
}

struct Product: Codable, Identifiable {
    let id: String
    let categoryId: String
    let name: String
    let description: String
    let baseImages: [String]
    
    let variants: [ProductVariant]
}

enum OptionType: String, Codable {
    case color
    case storage
    case connectivity
    case chip
    case ram
    case size
}


struct ProductVariant: Codable, Identifiable {
    let id: String
    let price: Int
    let stock: Int
    let images: [String]
    
    let attributes: [String: String]
}
