//
//  MonthlyCostSummaryViewController.swift
//  Subscriptions
//
//  Created by Filip Kaźmierczak on 17/07/2025.
//

import UIKit
import SwiftUI
import Combine

final class MonthlyCostSummaryViewController: UITableViewController {
    
    private var groupedData: [Subscription.Category: [Subscription]] = [:]
    
    init(subscriptions: [Subscription]) {
        super.init(style: .insetGrouped)
        self.groupedData = Dictionary(grouping: subscriptions, by: { $0.category })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with subscriptions: [Subscription]) {
        groupedData = Dictionary(grouping: subscriptions, by: { $0.category })
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        groupedData.keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = Array(groupedData.keys)[section]
        return category.displayName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(groupedData.keys)[section]
        return groupedData[category]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = Array(groupedData.keys)[indexPath.section]
        let subscription = groupedData[category]![indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = subscription.name
        content.secondaryText = String(format: "%.2f zł", subscription.monthlyCost)
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let category = Array(groupedData.keys)[section]
        let total = groupedData[category]?.map(\.monthlyCost).reduce(0, +) ?? 0
        return "Razem: \(String(format: "%.2f zł", total))"
    }
}
