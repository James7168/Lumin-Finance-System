//
//  DashboardView.swift
//  Lumin
//
//  Created by James on 11/01/2026.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(UserSettings.self) private var settings

    @Query(sort: \Account.name) private var accounts: [Account]
    @Query(sort: \AccountTransaction.date, order: .reverse) private var transactions: [AccountTransaction]

    @State private var showingResetConfirmation = false
    @State private var showingProfile = false

    @Binding var selectedTab: AppTab
    
    @State private var path = NavigationPath()

    private var recentTransactions: ArraySlice<AccountTransaction> {
        transactions.prefix(3)
    }

    private var totalWealth: Decimal {
        accounts.reduce(Decimal(0)) { total, account in
            total + FX.convert(
                account.currentBalance,
                from: account.currencyCode,
                to: settings.baseCurrency.rawValue
            )
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 12) {
                    header
                    totalWealthCard
                    accountsCard
                    recentTransactionsCard
                }
            }
            .customBackground()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Profile", systemImage: "person") { showingProfile = true }
                        .sheet(isPresented: $showingProfile) {
                            ProfileView()
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.height(300)])
                        }
                }

                ToolbarItem {
                    Menu("Add", systemImage: "plus") {
                        NavigationLink { AddAccountView() } label: {
                            Label("Add account", systemImage: "plus")
                        }
                        NavigationLink { AddTransactionView() } label: {
                            Label("Add transaction", systemImage: "plus")
                        }
                    }
                }

                ToolbarItem {
                    Button("Reset") { showingResetConfirmation = true }
                }
            }
            .alert("Data Reset", isPresented: $showingResetConfirmation) {
                Button("Confirm", role: .destructive) {
                    resetDataToDemo()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Reset all data back to the initial demo state?")
            }
        }
        .onAppear {
            if accounts.isEmpty {
                try? DemoData.launchDemoData(into: modelContext)
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Welcome to")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Lumin")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
    }

    private var totalWealthCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total wealth")
                .whiteTitleText()

            Text(totalWealth, format: .currency(code: settings.baseCurrency.rawValue).presentation(.narrow))
                .whiteLargeTitleText()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(21)
        .customContainer()
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
    }

    private var accountsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Accounts")
                .whiteTitleText()

            VStack(spacing: 0) {
                ForEach(accounts) { account in
                    NavigationLink {
                        FocusedAccountView(account: account)
                    } label: {
                        HStack {
                            Image(account.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.name)
                                    .whiteBodyText().opacity(0.7)
                                Text(account.currentBalance,
                                     format: .currency(code: account.currencyCode).presentation(.narrow)
                                )
                                .whiteTitleText()
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                        }
                        .padding(17)
                    }
                }
            }
            .customContainer()
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .padding(21)
        .customContainer()
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var recentTransactionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent transactions")
                .whiteTitleText()
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(recentTransactions) { transaction in
                    NavigationLink {
                        FocusedTransactionView(transaction: transaction)
                    } label: {
                        HStack {
                            Image(transaction.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(transaction.title).whiteTitleText()
                                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                    .whiteBodyText().opacity(0.7)
                            }

                            Spacer()

                            Text(transaction.amount,
                                 format: .currency(code: transaction.account.currencyCode).presentation(.narrow)
                            )
                            .whiteTitleText()
                        }
                        .padding(17)
                    }
                }

                Button("See all") {
                    selectedTab = .transactions
                }
                .padding()
            }
            .customContainer()
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }

    private func resetDataToDemo() {
        do {
            showingProfile = false
            showingResetConfirmation = false
            selectedTab = .dashboard
            path = NavigationPath()

            let allTransactions = try modelContext.fetch(FetchDescriptor<AccountTransaction>())
            allTransactions.forEach(modelContext.delete)

            let allAccounts = try modelContext.fetch(FetchDescriptor<Account>())
            allAccounts.forEach(modelContext.delete)

            try modelContext.save()

            try DemoData.launchDemoData(into: modelContext)

        } catch {
            print("Reset failed:", error)
        }
    }
}

private struct DashboardPreviewWrapper: View {
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        DashboardView(selectedTab: $selectedTab)
    }
}

#Preview {
    DashboardPreviewWrapper()
            .environment(UserSettings())
            .preferredColorScheme(.dark)
            .modelContainer(for: [Account.self, AccountTransaction.self], inMemory: true)
}
