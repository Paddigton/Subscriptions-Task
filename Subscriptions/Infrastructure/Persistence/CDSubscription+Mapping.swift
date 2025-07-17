//
//  CDSubscription+Mapping.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation
import CoreData

extension CDSubscription {
    
    func toDomain() -> Subscription {
        return Subscription(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            category: Subscription.Category(rawValue: self.categoryRaw ?? "") ?? .entertainment,
            monthlyCost: self.monthlyCost,
            createdAt: self.createdAt ?? Date(),
            renewalDate: self.renewalDate,
            platform: self.platform,
            storageGB: self.storageGB,
            provider: self.provider,
            planType: self.planType,
            paymentFrequency: self.paymentFrequency,
            gymName: self.gymName
        )
    }
    
    func populate(from subscription: Subscription) {
        self.id = subscription.id
        self.name = subscription.name
        self.categoryRaw = subscription.category.rawValue
        self.monthlyCost = subscription.monthlyCost
        self.createdAt = subscription.createdAt

        self.renewalDate = subscription.renewalDate
        self.platform = subscription.platform

        self.storageGB = subscription.storageGB ?? -1.0
        self.provider = subscription.provider

        self.planType = subscription.planType
        self.paymentFrequency = subscription.paymentFrequency
        self.gymName = subscription.gymName
    }
}
