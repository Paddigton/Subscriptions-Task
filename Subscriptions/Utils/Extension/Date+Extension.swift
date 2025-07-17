//
//  Data+Extension.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

extension Date {
    func asShortDate() -> String {
        formatted(.dateTime.day().month().year().locale(Locale(identifier: "pl_PL")))
    }
}
