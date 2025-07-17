//
//  SubscriptionsApp.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 14/07/2025.
//

import SwiftUI

@main
struct SubscriptionsApp: App {
    @AppStorage("dataSource") private var dataSource: String = "CoreData"

    var body: some Scene {
        WindowGroup {
            let container: DIContainer = {
                switch dataSource {
                case "Mock": return DIContainer.withMockData()
                default: return DIContainer.withCoreData()
                }
            }()
            
            ContentView()
                .environmentObject(container)
        }
    }
}
