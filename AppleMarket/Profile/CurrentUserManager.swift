//
//  CurrentUserManager.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.07.2026.
//

import Foundation

protocol CurrentUserManagerProtocol: AnyObject {
    var user: UserModel? { get }
    
    func setUser(_ user: UserModel)
    func clearUser()
}

final class CurrentUserManager: CurrentUserManagerProtocol {
    
    private(set) var user: UserModel?
    
    func setUser(_ user: UserModel) {
        self.user = user
    }
    
    func clearUser() {
        user = nil
    }
}
