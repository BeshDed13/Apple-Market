//
//  AuthState.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 27.07.2026.
//

import Foundation

enum AuthState {
    case loading
    case guest
    case authorized(UserModel)
}
