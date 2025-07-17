//
//  SubscriptionDetailView.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import SwiftUI

struct SubscriptionDetailView: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    let subscription: Subscription
    @State private var showingAddSheet = false

    var body: some View {
        Form {
            Section(header: Text("Ogólne")) {
                rowText(rowName: "Nazwa:", rowValue: subscription.name)
                rowText(rowName: "Kategoria:", rowValue: subscription.category.displayName)
                rowText(rowName: "Koszt miesięczny:", rowValue: subscription.monthlyCost.asCurrency())
                rowText(rowName: "Dodano:", rowValue: subscription.createdAt.asShortDate())
            }

            switch subscription.category {
            case .entertainment:
                Section(header: Text(subscription.category.displayName)) {
                    if let platform = subscription.platform {
                        rowText(rowName: "Platforma:", rowValue: platform)
                    }
                    if let date = subscription.renewalDate {
                        rowText(rowName: "Data odnowienia:", rowValue: date.asShortDate())
                    }
                }

            case .cloud:
                Section(header: Text(subscription.category.displayName)) {
                    if let gb = subscription.storageGB {
                        rowText(rowName: "Pojemność:", rowValue: String(format: "%.1f GB", gb))
                    }
                    if let provider = subscription.provider {
                        rowText(rowName: "Dostawca:", rowValue: provider)
                    }
                }

            case .fitness:
                Section(header: Text(subscription.category.displayName)) {
                    if let plan = subscription.planType {
                        rowText(rowName: "Typ planu:", rowValue: plan)
                    }
                    if let frequency = subscription.paymentFrequency {
                        rowText(rowName: "Częstotliwość płatności:", rowValue: frequency)
                    }
                    if let gym = subscription.gymName {
                        rowText(rowName: "Siłownia:", rowValue: gym)
                    }
                }

            case .productivity:
                Text("Brak dodatkowych pól.")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edytuj") {
                    showingAddSheet = true
                }
            }
        }
        .fullScreenCover(isPresented: $showingAddSheet) {
            AddOrEditSubscriptionView(
                subscriptionFormMode: .edit(subscription)
            ) { updated in
                viewModel.updateSubscription(updated)
            }
        }
        .navigationTitle(subscription.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func rowText(rowName: String, rowValue: String) -> some View {
        HStack {
            Text(rowName)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(rowValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
