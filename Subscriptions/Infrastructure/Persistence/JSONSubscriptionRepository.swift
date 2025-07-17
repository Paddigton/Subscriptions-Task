//
//  JSONSubscriptionRepository.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

final class JSONSubscriptionRepository: SubscriptionRepositoryProtocol {
    private let dataStore = SubscriptionDataStore()

    func fetchAll() throws -> [Subscription] {
        let data = try dataStore.loadJSON()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Subscription].self, from: data)
    }

    func save(_ subscription: Subscription) throws {
        var current = try fetchAll()
        current.append(subscription)
        try dataStore.saveJSON(current)
    }

    func update(_ subscription: Subscription) throws {
        var current = try fetchAll()
        if let index = current.firstIndex(where: { $0.id == subscription.id }) {
            current[index] = subscription
            try dataStore.saveJSON(current)
        } else {
            throw NSError(domain: "NotFound", code: 404, userInfo: nil)
        }
    }
    
    func delete(_ subscription: Subscription) throws {
        var current = try fetchAll()
        current.removeAll { $0.id == subscription.id }
        try dataStore.saveJSON(current)
    }
}
