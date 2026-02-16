//
//  UserSettings.swift
//  Lumin
//
//  Created by James on 14/01/2026.
//

import Foundation
import Observation

enum Currency: String, CaseIterable, Identifiable {
    case GBP, USD, EUR
    var id: String { rawValue }
}

@Observable
final class UserSettings {
    var baseCurrency: Currency = .GBP
}
