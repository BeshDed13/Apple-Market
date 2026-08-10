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
    private let categoryFactory: CategoryFactory
    private let productFactory: ProductFactory
    
    init(
        navigationController: UINavigationController,
        catalogFactory: CatalogFactory,
        categoryFactory: CategoryFactory,
        productFactory: ProductFactory
    ) {
        self.navigationController = navigationController
        self.catalogFactory = catalogFactory
        self.categoryFactory = categoryFactory
        self.productFactory = productFactory
    }
    
    func start() {
        let vc = catalogFactory.make()
        
        vc.onCategoryTapped = { [weak self] category in
            self?.showProducts(for: category)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProducts(for category: CatalogCategory) {
        let vc = categoryFactory.make(category: category)
        
        vc.onProductTapped = { [weak self] product in
            self?.showProduct(product)
        }

        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func showProduct(_ product: Product) {
        guard let productId = product.id else { return }
        let vc = productFactory.make(productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
}

