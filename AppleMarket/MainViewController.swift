//
//  MainViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI () {
        navigationItem.title = "Главная"
        view.backgroundColor = DesignSystem.Colors.primary
    }

}
