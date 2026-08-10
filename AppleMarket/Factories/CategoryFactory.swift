//
//  CategoryFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 08.08.2026.
//

import UIKit

final class CategoryFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make(category: CatalogCategory) -> CategoryViewController {

        let viewModel = CategoryViewModel(
            catalogService: container.catalogService,
            categoryId: category.id
        )

        let vc = CategoryViewController(
            viewModel: viewModel
        )

        vc.navigationItem.title = category.title

        return vc
    }
}
