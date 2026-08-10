//
//  CatalogService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 05.08.2026.
//

import FirebaseFirestore

protocol CatalogServiceProtocol {

    func fetchProducts(
        categoryId: String,
        completion: @escaping (Result<[Product], Error>) -> Void
    )
    
    func fetchProduct(
        id: String,
        completion: @escaping (Result<Product, Error>) -> Void
    )

    func fetchVariants(
        productId: String,
        completion: @escaping (Result<[ProductVariant], Error>) -> Void
    )
}

final class CatalogService: CatalogServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchProducts(
        categoryId: String,
        completion: @escaping (Result<[Product], Error>) -> Void
    ) {
        db.collection("products")
            .whereField("categoryId", isEqualTo: categoryId)
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
                    let products = try documents.map {
                        try $0.data(as: Product.self)
                    }

                    completion(.success(products))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func fetchProduct(
        id: String,
        completion: @escaping (Result<Product, Error>) -> Void
    ) {
        db.collection("products")
            .document(id)
            .getDocument { document, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let document else {
                    completion(
                        .failure(
                            NSError(
                                domain: "CatalogService",
                                code: 404,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Товар не найден"
                                ]
                            )
                        )
                    )
                    return
                }

                do {
                    let product = try document.data(as: Product.self)
                    completion(.success(product))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func fetchVariants(
        productId: String,
        completion: @escaping (Result<[ProductVariant], Error>) -> Void
    ) {
        db.collection("products")
            .document(productId)
            .collection("variants")
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
                    let variants = try documents.map {
                        try $0.data(as: ProductVariant.self)
                    }

                    completion(.success(variants))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
