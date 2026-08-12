//
//  FavoritesService.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import CoreData

protocol FavoritesServiceProtocol {
    func isFavorite(productID: String) -> Bool
    func add(productID: String)
    func remove(productID: String)
    @discardableResult
    func toggle(productID: String) -> Bool
    func fetchFavoriteIDs() -> [String]
}

final class FavoritesService: FavoritesServiceProtocol {

    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext = CoreDataManager.shared.context
    ) {
        self.context = context
    }

    func isFavorite(productID: String) -> Bool {
        let request = FavoriteProduct.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            productID
        )

        do {
            return try context.count(for: request) > 0
        } catch {
            print("Failed to check favorite:", error)
            return false
        }
    }

    func add(productID: String) {
        guard !isFavorite(productID: productID) else {
            return
        }

        let favorite = FavoriteProduct(context: context)
        favorite.id = productID

        save()
    }

    func remove(productID: String) {
        let request = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            productID
        )

        do {
            let favorites = try context.fetch(request)

            favorites.forEach {
                context.delete($0)
            }

            save()
        } catch {
            print("Failed to remove favorite:", error)
        }
    }

    @discardableResult
    func toggle(productID: String) -> Bool {
        if isFavorite(productID: productID) {
            remove(productID: productID)
            return false
        } else {
            add(productID: productID)
            return true
        }
    }

    func fetchFavoriteIDs() -> [String] {
        let request = FavoriteProduct.fetchRequest()

        do {
            let favorites = try context.fetch(request)

            return favorites.compactMap {
                $0.id
            }
        } catch {
            print("Failed to fetch favorites:", error)
            return []
        }
    }

    private func save() {
        guard context.hasChanges else {
            return
        }

        do {
            try context.save()
        } catch {
            print("Failed to save favorites:", error)
        }
    }
}
