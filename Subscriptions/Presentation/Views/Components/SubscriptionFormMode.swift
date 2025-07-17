//
//  EditMode.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

enum SubscriptionFormMode: Equatable {
    case add
    case edit(Subscription)
    
    static func == (lhs: SubscriptionFormMode, rhs: SubscriptionFormMode) -> Bool {
        switch (lhs, rhs) {
        case (.add, .add):
            return true
        case (.edit(let a), .edit(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}
