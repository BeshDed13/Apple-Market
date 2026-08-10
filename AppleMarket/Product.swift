//
//  Product.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 04.07.2026.
//

import Foundation
import FirebaseFirestore

struct Category: Codable, Identifiable {
    let id: String
    let name: String
    let icon: String
}

struct Product: Codable, Identifiable {
    @DocumentID var id: String?
    let isAvailable: Bool
    let categoryId: String
    let name: String
    let description: String
    let baseImage: String
    let minPrice: String
}

enum OptionType: String, Codable {
    case color
    case storage
    case connectivity
    case chip
    case ram
    case diagonal
}


struct ProductVariant: Codable, Identifiable {
    @DocumentID var id: String?
    let price: Int
    let stock: Int
    let images: [String]
    let attributes: [String: String]
}
