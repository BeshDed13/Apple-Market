//
//  FavoritesCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.07.2026.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let favoritesFactory: FavoritesFactory
    
    init(
        navigationController: UINavigationController,
        favoritesFactory: FavoritesFactory
    ) {
        self.navigationController = navigationController
        self.favoritesFactory = favoritesFactory
    }
    
    func start() {
        let vc = favoritesFactory.make()
        navigationController.pushViewController(vc, animated: true)
    }
}

