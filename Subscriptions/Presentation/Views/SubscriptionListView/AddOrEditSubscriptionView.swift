//
//  AddSubscriptionView.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import SwiftUI

struct AddOrEditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var category: Subscription.Category = .entertainment
    @State private var monthlyCost = ""

    @State private var platform = ""
    @State private var renewalDate = Date()

    @State private var storageGB = ""
    @State private var provider = ""

    @State private var planType = ""
    @State private var paymentFrequency = ""
    @State private var gymName = ""
    
    let subscriptionFormMode: SubscriptionFormMode
    let onSave: (Subscription) -> Void
    
    init(
        subscriptionFormMode: SubscriptionFormMode,
        onSave: @escaping (Subscription) -> Void
    ) {
        self.subscriptionFormMode = subscriptionFormMode
        self.onSave = onSave

        switch subscriptionFormMode {
        case .add:
            break
        case .edit(let subscription):
            _name = State(initialValue: subscription.name)
            _category = State(initialValue: subscription.category)
            _monthlyCost = State(initialValue: String(subscription.monthlyCost))

            _platform = State(initialValue: subscription.platform ?? "")
            _renewalDate = State(initialValue: subscription.renewalDate ?? Date())

            _storageGB = State(initialValue: subscription.storageGB.map { String($0) } ?? "")
            _provider = State(initialValue: subscription.provider ?? "")

            _planType = State(initialValue: subscription.planType ?? "")
            _paymentFrequency = State(initialValue: subscription.paymentFrequency ?? "")
            _gymName = State(initialValue: subscription.gymName ?? "")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                contentView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(subscriptionFormMode == .add ? "Nowa subskrypcja" : "Edytuj subskrypcję")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(subscriptionFormMode == .add ? "Dodaj" : "Zapisz") {
                        addOrEdit()
                    }
                    .tint(.black)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        TextField("Nazwa", text: $name)
        TextField("Cena miesięczna", text: $monthlyCost)
            .keyboardType(.decimalPad)
            .onChange(of: monthlyCost) { _, newValue in
                var filtered = newValue.replacingOccurrences(of: ",", with: ".")
                
                filtered = filtered.filter { "0123456789.".contains($0) }
                
                let parts = filtered.components(separatedBy: ".")
                if parts.count > 2 {
                    filtered = parts[0] + "." + parts[1]
                }
                
                if let dotIndex = filtered.firstIndex(of: ".") {
                    let decimals = filtered[filtered.index(after: dotIndex)...]
                    if decimals.count > 2 {
                        let endIndex = filtered.index(dotIndex, offsetBy: 3) // 1 (kropka) + 2 (miejsca)
                        filtered = String(filtered[..<endIndex])
                    }
                }
                
                if filtered != monthlyCost {
                    monthlyCost = filtered
                }
            }
        
        Picker("Kategoria", selection: $category) {
            ForEach(Subscription.Category.allCases, id: \.self) {
                Text($0.displayName)
            }
        }
        
        switch category {
        case .entertainment:
            Section(header: Text("Rozrywka")) {
                TextField("Platforma", text: $platform)
                DatePicker("Data odnowienia", selection: $renewalDate, displayedComponents: .date)
            }

        case .cloud:
            Section(header: Text("Chmura")) {
                TextField("Dostawca", text: $provider)
                TextField("Pojemność (GB)", text: $storageGB)
                    .keyboardType(.numberPad)
            }

        case .fitness:
            Section(header: Text("Fitness")) {
                TextField("Typ planu", text: $planType)
                TextField("Częstotliwość płatności", text: $paymentFrequency)
                TextField("Siłownia", text: $gymName)
            }

        case .productivity:
            EmptyView()
        }
    }
    
    private func addOrEdit() {
        guard let cost = Double(monthlyCost) else { return }

        let id: UUID
        let createdAt: Date

        switch subscriptionFormMode {
        case .add:
            id = UUID()
            createdAt = Date()
        case .edit(let sub):
            id = sub.id
            createdAt = sub.createdAt
        }

        var newSub = Subscription(
            id: id,
            name: name,
            category: category,
            monthlyCost: cost,
            createdAt: createdAt
        )

        switch category {
        case .entertainment:
            newSub.platform = platform
            newSub.renewalDate = renewalDate
        case .cloud:
            newSub.provider = provider
            newSub.storageGB = Double(storageGB)
        case .fitness:
            newSub.planType = planType
            newSub.paymentFrequency = paymentFrequency
            newSub.gymName = gymName
        case .productivity:
            break
        }

        onSave(newSub)
        dismiss()
    }
}
