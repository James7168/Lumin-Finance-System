//
//  ContentView.swift
//  Lumin
//
//  Created by James on 10/01/2026.
//

import SwiftData
import SwiftUI

enum AppTab: Hashable {
    case dashboard
    case accounts
    case transactions
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .dashboard
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(AppTab.dashboard)

            AccountsView()
                .tabItem { Label("Accounts", systemImage: "creditcard") }
                .tag(AppTab.accounts)

            TransactionsView()
                .tabItem { Label("Transactions", systemImage: "list.bullet") }
                .tag(AppTab.transactions)
        }
    }
}

#Preview {
    ContentView()
        .environment(UserSettings())
        .modelContainer(for: [Account.self, AccountTransaction.self], inMemory: true)
        .preferredColorScheme(.dark)
}
