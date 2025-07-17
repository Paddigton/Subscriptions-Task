//
//  SubscriptionRepositoryProtocol.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 15/07/2025.
//

import Foundation

protocol SubscriptionRepositoryProtocol {
    func fetchAll() throws -> [Subscription]
    func save(_ subscription: Subscription) throws
    func update(_ subscription: Subscription) throws
    func delete(_ subscription: Subscription) throws
}
