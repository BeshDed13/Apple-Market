//
//  AppCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 25.06.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let container: AppContainer

    init(
        navigationController: UINavigationController,
        container: AppContainer
    ) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        
        let mainFactory = MainFactory(container: container)
        let catalogFactory = CatalogFactory(container: container)
        let favoritesFactory = FavoritesFactory(container: container)
        let cartFactory = CartFactory(container: container)
        let profileFactory = ProfileFactory(container: container)
        let loginFactory = LoginFactory(container: container)
        let signUpFactory = SignUpFactory(container: container)
        let categoryFactory = CategoryFactory(container: container)
        let productFactory = ProductFactory(container: container)
        let ordersFactory = OrdersFactory(container: container)
        let settingsFactory = SettingsFactory(container: container)
        let supportFactory = SupportFactory(container: container)
        let notificationsFactory = NotificationsFactory(container: container)
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            mainFactory: mainFactory,
            catalogFactory: catalogFactory,
            favoritesFactory: favoritesFactory,
            cartFactory: cartFactory,
            profileFactory: profileFactory,
            loginFactory: loginFactory,
            signUpFactory: signUpFactory,
            categoryFactory: categoryFactory,
            productFactory: productFactory,
            ordersFactory: ordersFactory,
            settingsFactory: settingsFactory,
            supportFactory: supportFactory,
            notificationsFactory: notificationsFactory
            
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
