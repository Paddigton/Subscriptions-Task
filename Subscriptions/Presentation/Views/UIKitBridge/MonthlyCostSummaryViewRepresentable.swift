//
//  MonthlyCostSummaryViewRepresentable.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 17/07/2025.
//

import SwiftUI

struct MonthlyCostSummaryViewRepresentable: UIViewControllerRepresentable {
    let subscriptions: [Subscription]

    func makeUIViewController(context: Context) -> UINavigationController {
        let summaryViewController = MonthlyCostSummaryViewController(subscriptions: subscriptions)
        summaryViewController.title = "Podsumowanie"
        summaryViewController.navigationItem.largeTitleDisplayMode = .never

        let navController = UINavigationController(rootViewController: summaryViewController)
        return navController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let summaryViewController = uiViewController.viewControllers.first as? MonthlyCostSummaryViewController {
            summaryViewController.update(with: subscriptions)
        }
    }
}
