//
//  ContentView.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 14/07/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject private var viewModel = SubscriptionViewModel()
    
    @State private var activeTab: Tab = .start
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                SubscriptionListView(
                    viewModel: viewModel
                ).setUpTab(.start)
                
                MonthlyCostSummaryViewRepresentable(
                    subscriptions: viewModel.subscriptions
                )
                .setUpTab(.summary)
                .ignoresSafeArea(.container, edges: .top)
                
                SettingsView()
                    .setUpTab(.settings)
            }
            .accentColor(.black)
            CustomTabBarV2()
        }
        .onAppear() {
            viewModel.setRepository(container.subscriptionRepository)
        }
        .onReceive(container.$subscriptionRepository) { newRepo in
            viewModel.setRepository(newRepo)
            viewModel.loadSubscriptions()
        }

    }


    @ViewBuilder
    func CustomTabBarV2() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                VStack(spacing: 4) {
                    imageViewTab(tab: tab, animatedTab: animatedTab)
            
                    Text(LocalizedStringKey(tab.title))
                        .font(.system(size: 12.5))
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color(.black) : Color(.red).opacity(0.3))
                .padding(.top, 10)
                .padding(.bottom, 5)
                .contentShape(.rect)
                .onTapGesture {
                    handleTapGesture(for: tab, animatedTab: $animatedTab)
                }
            }
        }
        .background(
            Color(.gray).opacity(0.2)
        )
        .background(.bar)
    }
    
    @ViewBuilder
    func imageViewTab(tab: Tab, animatedTab: AnimatedTab) -> some View {
        ZStack(alignment: .topTrailing) {
            if #available(iOS 17.0, *) {
                Image(systemName: activeTab == tab ? tab.image : tab.rawValue)
                    .font(.system(size: 26))
                    .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)
            } else {
                Image(systemName: activeTab == tab ? tab.image : tab.rawValue)
                    .font(.system(size: 26))
            }
        }
    }
    
    private func handleTapGesture(for tab: Tab, animatedTab: Binding<AnimatedTab>) {
        if #available(iOS 17.0, *) {
            withAnimation(
                .bouncy,
                completionCriteria: .logicallyComplete, {
                    activeTab = tab
                    var localAnimatedTab = animatedTab.wrappedValue
                    localAnimatedTab.isAnimating = true
                    animatedTab.wrappedValue = localAnimatedTab
                }
            ) {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    var localAnimatedTab = animatedTab.wrappedValue
                    localAnimatedTab.isAnimating = false
                    animatedTab.wrappedValue = localAnimatedTab
                }
            }
        } else {
            withAnimation {
                activeTab = tab
            }
        }
    }
}
