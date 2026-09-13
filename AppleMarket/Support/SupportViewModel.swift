//
//  SupportViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import Foundation

protocol SupportViewModelProtocol: AnyObject {
    
    var messages: [SupportMessage] { get }
    
    var onMessagesUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadMessages()
    func sendMessage(text: String)
}

final class SupportViewModel: SupportViewModelProtocol {
    
    var onMessagesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let supportService: SupportServiceProtocol
    private let user: UserModel
    
    private(set) var messages: [SupportMessage] = []
    
    init(
        supportService: SupportServiceProtocol,
        user: UserModel
    ) {
        self.supportService = supportService
        self.user = user
    }
    
    func loadMessages() {
        
        supportService.fetchMessages(
            userId: user.id
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let messages):
                    self?.messages = messages
                    self?.onMessagesUpdated?()
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func sendMessage(text: String) {
        
        let trimmedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !trimmedText.isEmpty else {
            return
        }
        
        supportService.sendMessage(
            text: trimmedText,
            userId: user.id,
            sender: .user
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success:
                    self?.loadMessages()
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
}
