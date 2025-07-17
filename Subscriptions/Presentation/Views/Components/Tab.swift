//
//  Tab.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

enum Tab: String, CaseIterable {
    case start = "house"
    case summary = "wallet.pass"
    case settings = "person"
    
    var title: String {
        switch self {
        case .start:
            return "Start"
        case .summary:
            return "Summary"
        case .settings:
            return "Account"
        }
    }
    
    var image: String {
        switch self {
        case .start:
            return "house.fill"
        case .summary:
            return "wallet.pass"
        case .settings:
            return "person.fill"
        }
    }

}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
