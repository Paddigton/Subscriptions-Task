//
//  SettingsViewModel.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    private let container: DIContainer
    
    @Published var selectedSource: String {
        didSet {
            container.switchDataSource(to: selectedSource)
            UserDefaults.standard.set(selectedSource, forKey: "dataSource")
        }
    }

    init(container: DIContainer) {
        self.container = container
        self.selectedSource = UserDefaults.standard.string(forKey: "dataSource") ?? "CoreData"
    }
}
