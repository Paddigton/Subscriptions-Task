//
//  SubscriptionListView.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 16/07/2025.
//

import SwiftUI

struct SubscriptionListView: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @State private var showingAddSheet = false
    @State private var editedSubscription: Subscription?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.subscriptions) { sub in
                    NavigationLink(
                        destination: SubscriptionDetailView(
                            viewModel: viewModel,
                            subscription: sub
                        )
                    ) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(sub.name)
                                    .font(.headline)
                                Text(sub.category.displayName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(sub.monthlyCost, format: .currency(code: "PLN"))
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                editedSubscription = sub
                            } label: {
                                Label("Edytuj", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteSubscription)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .tint(.black)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddSheet) {
                AddOrEditSubscriptionView(
                    subscriptionFormMode: .add
                ) { newSubscription in
                    viewModel.addSubscription(newSubscription)
                }
            }
            .fullScreenCover(item: $editedSubscription) { sub in
                AddOrEditSubscriptionView(
                    subscriptionFormMode: .edit(sub)
                ) { updated in
                    viewModel.updateSubscription(updated)
                }
            }
            .navigationTitle("Subskrypcje")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadSubscriptions()
            }
        }
    }
}
