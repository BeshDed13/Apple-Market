//
//  AppContainer.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import Foundation

final class AppContainer {
    
    let authService: AuthServiceProtocol
    let userService: UserServiceProtocol
    let currentUserManager: CurrentUserManagerProtocol
    
    init() {
        authService = AuthService()
        userService = UserService()
        currentUserManager = CurrentUserManager()
    }
}
