//
//  Double+Extension.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

extension Double {
    func asCurrency(_ code: String = "PLN") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        return formatter.string(from: NSNumber(value: self)) ?? "-"
    }
}
