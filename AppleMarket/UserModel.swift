//
//  UserModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let avatar: Avatar
    
    var cartVariantIDs: [String]
    var favoriteProductIDs: [String]
    var orderIDs: [String]
}
