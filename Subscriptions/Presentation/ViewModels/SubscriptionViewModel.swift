//
//  SubscriptionListViewModel.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

final class SubscriptionViewModel: ObservableObject {
    
    private var repository: SubscriptionRepositoryProtocol?
        
    func setRepository(_ repository: SubscriptionRepositoryProtocol) {
        self.repository = repository
    }

    @Published var subscriptions: [Subscription] = []
    
    func loadSubscriptions() {
        guard let repository = repository else { return }
        do {
            subscriptions = try repository.fetchAll()
        } catch {
            print("Błąd ładowania: \(error)")
        }
    }
    
    func deleteSubscription(atOffsets offsets: IndexSet) {
        guard let repository = repository else { return }
        
        offsets.forEach { index in
            let subscription = subscriptions[index]
            do {
                try repository.delete(subscription)
            } catch {
                print("Błąd usuwania: \(error)")
            }
        }
        subscriptions.remove(atOffsets: offsets)
    }
    
    func addSubscription(_ subscription: Subscription) {
        guard let repository = repository else { return }
        do {
            try repository.save(subscription)
            subscriptions.append(subscription)
        } catch {
            print("Błąd dodawania subskrypcji: \(error)")
        }
    }
    
    func updateSubscription(_ subscription: Subscription) {
        guard let repository = repository else { return }
        do {
            try repository.update(subscription)
            if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
                subscriptions[index] = subscription
            }
        } catch {
            print("Błąd aktualizacji subskrypcji: \(error)")
        }
        
    }
    
}
