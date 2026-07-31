//
//  CatalogCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.07.2026.
//

import UIKit

final class CatalogCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let catalogFactory: CatalogFactory
    
    init(
        navigationController: UINavigationController,
        catalogFactory: CatalogFactory
    ) {
        self.navigationController = navigationController
        self.catalogFactory = catalogFactory
    }
    
    func start() {
        let vc = catalogFactory.make()
        navigationController.pushViewController(vc, animated: true)
    }
}

