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
    let catalogService: CatalogServiceProtocol
    let imageLoader: ImageLoaderProtocol
    let cartService: CartServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    
    init() {
        let userService = UserService()
        
        self.userService = userService
        self.authService = AuthService(userService: userService)
        self.currentUserManager = CurrentUserManager()
        self.catalogService = CatalogService()
        self.imageLoader = ImageLoader()
        self.cartService = CartService()
        self.favoritesService = FavoritesService()
    }
}
