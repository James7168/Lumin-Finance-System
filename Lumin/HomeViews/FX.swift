//
//  FX.swift
//  Lumin
//
//  Created by James on 14/01/2026.
//

import Foundation

enum FX {
    private static let toGBP: [String: Decimal] = [
        "GBP": 1.0,
        "USD": 0.79,
        "EUR": 0.86
    ]

    static func convert(_ amount: Decimal, from source: String, to target: String) -> Decimal {
        let source = source.uppercased()
        let target = target.uppercased()

        guard let sourceToGBP = toGBP[source] else {
            assertionFailure("Missing FX rate for source currency: \(source)")
            return amount
        }
        guard let targetToGBP = toGBP[target] else {
            assertionFailure("Missing FX rate for target currency: \(target)")
            return amount
        }

        let amountInGBP = amount * sourceToGBP
        return amountInGBP / targetToGBP
    }
}
