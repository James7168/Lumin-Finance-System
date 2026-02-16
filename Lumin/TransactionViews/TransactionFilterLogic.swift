//
//  TransactionFilterLogic.swift
//  Lumin
//
//  Created by James on 14/01/2026.
//

import Foundation
import Observation

@Observable
final class TransactionFilter {
    var selectedAccountIDs: Set<UUID> = []

    var isFiltering: Bool { !selectedAccountIDs.isEmpty }

    func clear() {
        selectedAccountIDs.removeAll()
    }

    func setSelected(ids: Set<UUID>) {
        selectedAccountIDs = ids
    }

    func selectAll(ids: [UUID]) {
        selectedAccountIDs = Set(ids)
    }

    func toggle(id: UUID) {
        if selectedAccountIDs.contains(id) {
            selectedAccountIDs.remove(id)
        } else {
            selectedAccountIDs.insert(id)
        }
    }

    func includes(_ id: UUID) -> Bool {
        selectedAccountIDs.isEmpty || selectedAccountIDs.contains(id)
    }
}
