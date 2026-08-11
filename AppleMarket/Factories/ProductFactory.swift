//
//  ProductFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 08.08.2026.
//

import Foundation

final class ProductFactory {

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func make(productId: String) -> ProductViewController {

        let viewModel = ProductViewModel(
            catalogService: container.catalogService,
            productId: productId,
            cartService: container.cartService,
            authService: container.authService
        )

        return ProductViewController(
            viewModel: viewModel,
            imageLoader: container.imageLoader
        )
    }
}
