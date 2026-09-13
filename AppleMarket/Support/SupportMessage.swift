//
//  SupportMessage.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import FirebaseFirestore

enum MessageSender: String, Codable {
    case user
    case support
}

struct SupportMessage: Codable {
    @DocumentID var id: String?
    let text: String
    let sender: MessageSender
    let createdAt: Date
}
