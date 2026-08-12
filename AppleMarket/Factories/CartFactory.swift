//
//  CartFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

final class CartFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> CartViewController {
        let viewModel = CartViewModel(
            authService: container.authService,
            cartService: container.cartService,
            catalogService: container.catalogService
            )
        return CartViewController(
            viewModel: viewModel,
            imageLoader: container.imageLoader
        )
    }
}
