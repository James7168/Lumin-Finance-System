//
//  Account.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import Foundation
import SwiftData

@Model
final class Account {
    @Attribute(.unique) var id: UUID
    var name: String
    var currencyCode: String
    var startingBalance: Decimal
    var imageName: String

    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]

    init(
        id: UUID = UUID(),
        name: String,
        currencyCode: String,
        startingBalance: Decimal,
        imageName: String,
        transactions: [AccountTransaction] = []
    ) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!trimmed.isEmpty, "Account name must not be empty.")
        precondition(startingBalance >= 0, "Starting balance must be >= 0.")
        precondition(currencyCode.count == 3, "currencyCode should be 3 letters.")

        self.id = id
        self.name = trimmed
        self.currencyCode = currencyCode.uppercased()
        self.startingBalance = startingBalance
        self.imageName = imageName
        self.transactions = transactions
    }
}

extension Account {
    var currentBalance: Decimal {
        startingBalance + transactions.reduce(Decimal(0)) { $0 + $1.amount }
    }
}
