//
//  Subscription.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 15/07/2025.
//

import Foundation

struct Subscription: Identifiable, Codable {
    enum Category: String, Codable, CaseIterable {
        case entertainment
        case productivity
        case cloud
        case fitness
        
        var displayName: String {
            switch self {
            case .entertainment:
                return "Rozrywka"
            case .productivity:
                return "Produktywność"
            case .cloud:
                return "Chmura"
            case .fitness:
                return "Fitness"
            }
        }
    }

    let id: UUID
    var name: String
    var category: Category
    var monthlyCost: Double
    var createdAt: Date

    
    var renewalDate: Date?
    var platform: String?
    
    var storageGB: Double?
    var provider: String?
    
    var planType: String?
    var paymentFrequency: String?
    var gymName: String?
}
