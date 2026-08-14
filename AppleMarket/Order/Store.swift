//
//  Store.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import Foundation
import FirebaseFirestore

struct Store: Codable {
    @DocumentID var id: String?
    let name: String
}
