//
//  CartError.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import Foundation

enum CartError: LocalizedError {

    case notAuthorized
    case invalidVariant
    case itemNotFound
    case outOfStock

    var errorDescription: String? {

        switch self {

        case .notAuthorized:
            return "Для работы с корзиной необходимо войти в аккаунт."

        case .invalidVariant:
            return "Не удалось определить вариант товара."

        case .itemNotFound:
            return "Товар не найден в корзине."

        case .outOfStock:
            return "Недостаточно товара на складе."
        }
    }
}
