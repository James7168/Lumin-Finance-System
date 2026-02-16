//
//  AccountTransaction.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import Foundation
import SwiftData

@Model
final class AccountTransaction {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var date: Date
    var title: String
    var imageName: String

    @Relationship var account: Account
    
    // Single source of truth from linked account.
    var currencyCode: String { account.currencyCode }

    init(
        id: UUID = UUID(),
        amount: Decimal,
        date: Date = .now,
        title: String,
        imageName: String = "TransactionImage3",
        account: Account
    ) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!trimmed.isEmpty, "Transaction title must not be empty.")
        precondition(amount != 0, "Transaction amount must not be 0.")

        self.id = id
        self.amount = amount
        self.date = date
        self.title = trimmed
        self.imageName = imageName
        self.account = account
    }
}
