//
//  TabBarCoordinator.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 03.07.2026.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let tabBarController = UITabBarController()
    
    private let mainFactory: MainFactory
    private let catalogFactory: CatalogFactory
    private let favoritesFactory: FavoritesFactory
    private let cartFactory: CartFactory
    private let profileFactory: ProfileFactory
    private let loginFactory: LoginFactory
    private let signUpFactory: SignUpFactory
    private let categoryFactory: CategoryFactory
    private let productFactory: ProductFactory
    private let ordersFactory: OrdersFactory
    private let settingsFactory: SettingsFactory
    private let supportFactory: SupportFactory
    private let notificationsFactory: NotificationsFactory
    
    init(
        navigationController: UINavigationController,
        mainFactory: MainFactory,
        catalogFactory: CatalogFactory,
        favoritesFactory: FavoritesFactory,
        cartFactory: CartFactory,
        profileFactory: ProfileFactory,
        loginFactory: LoginFactory,
        signUpFactory: SignUpFactory,
        categoryFactory: CategoryFactory,
        productFactory: ProductFactory,
        ordersFactory: OrdersFactory,
        settingsFactory: SettingsFactory,
        supportFactory: SupportFactory,
        notificationsFactory: NotificationsFactory
    ) {
        self.navigationController = navigationController
        self.mainFactory = mainFactory
        self.catalogFactory = catalogFactory
        self.favoritesFactory = favoritesFactory
        self.cartFactory = cartFactory
        self.profileFactory = profileFactory
        self.loginFactory = loginFactory
        self.signUpFactory = signUpFactory
        self.categoryFactory = categoryFactory
        self.productFactory = productFactory
        self.ordersFactory = ordersFactory
        self.settingsFactory = settingsFactory
        self.supportFactory = supportFactory
        self.notificationsFactory = notificationsFactory
    }
    func start() {
        
        let mainNC = UINavigationController()
        let catalogNC = UINavigationController()
        let cartNC = UINavigationController()
        let favoritesNC = UINavigationController()
        let profileNC = UINavigationController()
        let authNC = UINavigationController()
        
        let mainCoordinator = MainCoordinator(
            navigationController: mainNC,
            mainFactory: mainFactory
        )
        let catalogCoordinator = CatalogCoordinator(
            navigationController: catalogNC,
            catalogFactory: catalogFactory,
            categoryFactory: categoryFactory,
            productFactory: productFactory
        )
        let favoritesCoordinator = FavoritesCoordinator(
            navigationController: favoritesNC,
            favoritesFactory: favoritesFactory
        )
        let cartCoordinator = CartCoordinator(
            navigationController: cartNC,
            cartFactory: cartFactory
        )
        let profileCoordinator = ProfileCoordinator(
            navigationController: profileNC,
            profileFactory: profileFactory,
            ordersFactory: ordersFactory,
            settingsFactory: settingsFactory,
            supportFactory: supportFactory,
            notificationsFactory: notificationsFactory
        )
        let authCoordinator = AuthCoordinator(
            navigationController: authNC,
            loginFactory: loginFactory,
            signUpFactory: signUpFactory
        )
        
        catalogCoordinator.onLoginRequested = { [weak authCoordinator] in
            authCoordinator?.showLogin(from: catalogNC)
        }

        catalogCoordinator.onSignUpRequested = { [weak authCoordinator] in
            authCoordinator?.showSignUp(from: catalogNC)
        }
        
        cartCoordinator.onLoginRequested = { [weak authCoordinator] in
            authCoordinator?.showLogin(from: cartNC)
        }
        
        cartCoordinator.onSignUpRequested = { [weak authCoordinator] in
            authCoordinator?.showSignUp(from: cartNC)
        }
        
        profileCoordinator.onLoginRequested = { [weak authCoordinator] in
            authCoordinator?.showLogin(from: profileNC)
        }

        profileCoordinator.onSignUpRequested = { [weak authCoordinator] in
            authCoordinator?.showSignUp(from: profileNC)
        }
        
        childCoordinators = [mainCoordinator, catalogCoordinator, favoritesCoordinator, cartCoordinator, profileCoordinator, authCoordinator]
        
        mainCoordinator.start()
        catalogCoordinator.start()
        favoritesCoordinator.start()
        cartCoordinator.start()
        profileCoordinator.start()
        
        mainNC.tabBarItem = UITabBarItem(title: "Главная",
                                            image: UIImage(systemName: "house"),
                                            selectedImage: UIImage(systemName: "house.fill"))
    
        catalogNC.tabBarItem = UITabBarItem(title: "Каталог",
                                         image: UIImage(systemName: "square.grid.2x2"),
                                         selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        
        favoritesNC.tabBarItem = UITabBarItem(title: "Избранное",
                                            image: UIImage(systemName: "heart"),
                                            selectedImage: UIImage(systemName: "heart.fill"))
        
        cartNC.tabBarItem = UITabBarItem(title: "Корзина",
                                                    image: UIImage(systemName: "cart"),
                                                    selectedImage: UIImage(systemName: "cart.fill"))
        
        profileNC.tabBarItem = UITabBarItem(title: "Профиль",
                                                  image: UIImage(systemName: "person"),
                                                  selectedImage: UIImage(systemName: "person.fill"))
        
                                                          
        tabBarController.viewControllers = [mainNC, catalogNC, favoritesNC, cartNC, profileNC]
        
        navigationController.setViewControllers([tabBarController], animated: true)

    }
}

