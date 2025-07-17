//
//  SettingsView.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject private var viewModel: SettingsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(container: DIContainer.withCoreData()))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Źródło danych")
                ) {
                    Picker("Źródło danych", selection: $viewModel.selectedSource) {
                        Text("CoreData").tag("CoreData")
                        Text("Mock API (JSON)").tag("Mock")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .formStyle(.automatic)
            .navigationTitle("Ustawienia")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
