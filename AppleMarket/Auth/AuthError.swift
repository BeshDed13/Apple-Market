//
//  AuthError.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

enum AuthError: Error {
    case userNotCreated
}

enum UserError: LocalizedError {
    case userNotFound

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Пользователь не найден."
        }
    }
}
