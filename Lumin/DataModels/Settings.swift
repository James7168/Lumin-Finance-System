//
//  Settings.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import Foundation
import SwiftData

@Model
final class Settings {
    var homeCurrencyCode: String

    init(homeCurrencyCode: String = "GBP") {
        precondition(homeCurrencyCode.count == 3, "homeCurrencyCode should be ISO-4217 (3 letters).")
        self.homeCurrencyCode = homeCurrencyCode.uppercased()
    }
}
