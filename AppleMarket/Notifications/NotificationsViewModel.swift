//
//  NotificationsViewModel.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import Foundation

protocol NotificationsViewModelProtocol: AnyObject {
    
    var notifications: [AppNotification] { get }
    
    var onNotificationsUpdated: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadNotifications()
    func markAllAsRead()
}

final class NotificationsViewModel: NotificationsViewModelProtocol {
    
    var onNotificationsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let notificationService: NotificationServiceProtocol
    private let userId: String
    
    private(set) var notifications: [AppNotification] = []
    
    init(
        notificationService: NotificationServiceProtocol,
        userId: String
    ) {
        self.notificationService = notificationService
        self.userId = userId
    }
    
    func loadNotifications() {
        
        notificationService.fetchNotifications(
            userId: userId
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let notifications):
                    self?.notifications = notifications
                    self?.onNotificationsUpdated?()
                    
                    self?.markAllAsRead()
                    
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func markAllAsRead() {
        
        let unreadNotifications = notifications.filter {
            !$0.isRead
        }
        
        guard !unreadNotifications.isEmpty else {
            return
        }
        
        let group = DispatchGroup()
        
        for notification in unreadNotifications {
            
            guard let notificationId = notification.id else {
                continue
            }
            
            group.enter()
            
            notificationService.markAsRead(
                notificationId: notificationId,
                userId: userId
            ) { [weak self] result in
                
                switch result {
                    
                case .success:
                    break
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error)
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let self else {
                return
            }
            
            for index in self.notifications.indices {
                self.notifications[index].isRead = true
            }
            
            self.onNotificationsUpdated?()
        }
    }
}
