//
//  CoreDataSubscriptionRepository.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation
import CoreData

final class CoreDataSubscriptionRepository: SubscriptionRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [Subscription] {
        let request: NSFetchRequest<CDSubscription> = CDSubscription.fetchRequest()
        let results = try context.fetch(request)
        return results.map { $0.toDomain() }
    }
    
    func save(_ subscription: Subscription) throws {
        let entity = CDSubscription(context: context)
        entity.populate(from: subscription)
        try context.save()
    }
    
    func update(_ subscription: Subscription) throws {
        let request: NSFetchRequest<CDSubscription> = CDSubscription.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", subscription.id as CVarArg)

        if let entity = try context.fetch(request).first {
            entity.populate(from: subscription)
            try context.save()
        }
    }
    
    func delete(_ subscription: Subscription) throws {
        let request: NSFetchRequest<CDSubscription> = CDSubscription.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", subscription.id as CVarArg)

        let results = try context.fetch(request)
        for entity in results {
            context.delete(entity)
        }
        try context.save()
    }
}
