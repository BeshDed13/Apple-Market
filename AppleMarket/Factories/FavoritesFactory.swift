//
//  FavoritesFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

final class FavoritesFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> FavoritesViewController {
        let viewModel = FavoritesViewModel(
            favoritesService: container.favoritesService,
            catalogService: container.catalogService,
        )
        return FavoritesViewController(viewModel: viewModel)
    }
}
