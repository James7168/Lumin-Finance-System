//
//  TransactionFunctions.swift
//  Lumin
//
//  Created by James on 16/01/2026.
//

import Foundation

enum TransactionCurrencySymbol {
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 0
        return f
    }()
    
    static func symbol(for currencyCode: String) -> String {
        switch currencyCode.uppercased() {
        case "USD": return "$"
        case "GBP": return "£"
        case "EUR": return "€"
        default:
            formatter.currencyCode = currencyCode.uppercased()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.currencySymbol ?? currencyCode
        }
    }
}
