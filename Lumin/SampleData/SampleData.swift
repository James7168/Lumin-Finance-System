//
//  SampleData.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import SwiftData
import Foundation

enum DemoData {

    static func launchDemoData(into context: ModelContext) throws {

        let referenceDate = Calendar.current.startOfDay(for: Date())

        let accounts = [
            Account(id: UUID(), name: "Chase Account", currencyCode: "GBP", startingBalance: 5400, imageName: "GradientA", transactions: []),
            Account(id: UUID(), name: "AMEX Account", currencyCode: "USD", startingBalance: 10000, imageName: "GradientB", transactions: []),
            Account(id: UUID(), name: "HSBC Account", currencyCode: "EUR", startingBalance: 2200, imageName: "GradientG", transactions: [])
        ]

        accounts.forEach(context.insert)

        let demoTransactions: [(Account, [DemoTransaction])] = [
            (accounts[0], DemoTransaction.sampleSetA),
            (accounts[1], DemoTransaction.sampleSetB),
            (accounts[2], DemoTransaction.sampleSetC)
        ]

        for (account, transactions) in demoTransactions {
            for item in transactions {
                let transaction = AccountTransaction(
                    id: UUID(),
                    amount: item.amount,
                    date: referenceDate.addingTimeInterval(item.daysOffset),
                    title: item.title,
                    imageName: "TransactionGradient",
                    account: account
                )
                context.insert(transaction)
            }
        }

        try context.save()
    }
}

struct DemoTransaction {
    let amount: Decimal
    let daysOffset: TimeInterval
    let title: String

    static let day: TimeInterval = -86400

    static let sampleSetA: [DemoTransaction] = [
        .init(amount: 3200, daysOffset: day * 90, title: "Salary"),
        .init(amount: -1200, daysOffset: day * 80, title: "Rent"),
        .init(amount: -82.40, daysOffset: day * 72, title: "Groceries")
    ]

    static let sampleSetB: [DemoTransaction] = [
        .init(amount: -15.80, daysOffset: day * 87, title: "Lunch"),
        .init(amount: 250, daysOffset: day * 53, title: "Refund")
    ]

    static let sampleSetC: [DemoTransaction] = [
        .init(amount: 1800, daysOffset: day * 85, title: "Freelance Payment"),
        .init(amount: -650, daysOffset: day * 76, title: "Rent Contribution")
    ]
}
