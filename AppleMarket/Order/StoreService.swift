//
//  StoreService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import FirebaseFirestore

protocol StoreServiceProtocol {
    func fetchStores(completion: @escaping (Result<[Store], Error>) -> Void)
}

final class StoreService: StoreServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchStores(completion: @escaping (Result<[Store], Error>) -> Void) {
        db.collection("stores")
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
                    let stores = try documents.map {
                        try $0.data(as: Store.self)
                    }
                    
                    completion(.success(stores))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
