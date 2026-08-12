//
//  SupportFactory.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class SupportFactory {
    
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
    }
    
    func make() -> SupportViewController {
        SupportViewController()
    }
}
