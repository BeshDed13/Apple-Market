//
//  CoreDataManager.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 11.08.2026.
//

import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "AppleMarket")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
