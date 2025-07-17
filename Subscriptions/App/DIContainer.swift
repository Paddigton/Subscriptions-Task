//
//  DIContainer.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//
import Foundation

final class DIContainer: ObservableObject {
    @Published var subscriptionRepository: SubscriptionRepositoryProtocol
    
    init(repository: SubscriptionRepositoryProtocol) {
        self.subscriptionRepository = repository
    }
    
    func switchDataSource(to source: String) {
        switch source {
        case "CoreData":
            subscriptionRepository = CoreDataSubscriptionRepository(
                context: PersistenceController.shared.container.viewContext
            )
        case "Mock":
            subscriptionRepository = JSONSubscriptionRepository()
        default:
            break
        }
    }

    static func withCoreData() -> DIContainer {
        let repository = CoreDataSubscriptionRepository(context: PersistenceController.shared.container.viewContext)
        return DIContainer(repository: repository)
    }

    static func withMockData() -> DIContainer {
        let repository = JSONSubscriptionRepository()
        return DIContainer(repository: repository)
    }
}
