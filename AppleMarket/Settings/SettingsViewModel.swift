//
//  SettingsViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
    
    var userName: String { get }
    var userAvatar: Avatar { get }
    
    var onProfileUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func updateProfile(
        name: String,
        avatar: Avatar
    )
}

final class SettingsViewModel: SettingsViewModelProtocol {
    
    var onProfileUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let userService: UserServiceProtocol
    private let user: UserModel
    
    var userName: String {
        user.name
    }
    
    var userAvatar: Avatar {
        user.avatar
    }
    
    init(
        userService: UserServiceProtocol,
        user: UserModel
    ) {
        self.userService = userService
        self.user = user
    }
    
    func updateProfile(
        name: String,
        avatar: Avatar
    ) {
        
        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        userService.updateProfile(
            userId: user.id,
            name: trimmedName,
            avatar: avatar
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self?.onProfileUpdated?()
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
