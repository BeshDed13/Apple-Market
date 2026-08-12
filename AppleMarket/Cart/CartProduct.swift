//
//  CartProduct.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import Foundation

struct CartProduct {
    let product: Product
    let variant: ProductVariant
    var quantity: Int
    
    var totalPrice: Int {
        variant.price * quantity
    }
}
