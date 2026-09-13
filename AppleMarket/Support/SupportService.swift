//
//  SupportService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 14.08.2026.
//

import FirebaseFirestore

protocol SupportServiceProtocol {
    
    func fetchMessages(
        userId: String,
        completion: @escaping (Result<[SupportMessage], Error>) -> Void
    )
    
    func sendMessage(
        text: String,
        userId: String,
        sender: MessageSender,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SupportService: SupportServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchMessages(
        userId: String,
        completion: @escaping (Result<[SupportMessage], Error>) -> Void
    ) {
        
        db
            .collection("users")
            .document(userId)
            .collection("messages")
            .order(by: "createdAt")
            .getDocuments { snapshot, error in
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                do {
                    let messages = try documents.map {
                        try $0.data(as: SupportMessage.self)
                    }
                    
                    completion(.success(messages))
                    
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func sendMessage(
        text: String,
        userId: String,
        sender: MessageSender,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let messageReference = db
            .collection("users")
            .document(userId)
            .collection("messages")
            .document()
        
        let message = SupportMessage(
            id: messageReference.documentID,
            text: text,
            sender: sender,
            createdAt: Date()
        )
        
        do {
            try messageReference.setData(
                from: message
            ) { error in
                
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
            
        } catch {
            completion(.failure(error))
        }
    }
}
