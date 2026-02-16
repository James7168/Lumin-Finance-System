//
//  AccountsView.swift
//  Lumin
//
//  Created by James on 11/01/2026.
//

import SwiftData
import SwiftUI

struct AccountsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.name) private var accounts: [Account]

    var body: some View {
        NavigationStack {
            VStack {
                header

                List {
                    ForEach(accounts) { account in
                        NavigationLink {
                            FocusedAccountView(account: account)
                        } label: {
                            accountRow(account)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteAccounts([account])
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(21)
                    }
                    .onDelete { indexSet in
                        let toDelete = indexSet.map { accounts[$0] }
                        deleteAccounts(toDelete)
                    }
                }
                .listRowSpacing(0)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .customContainer()
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal)

                Spacer()
            }
            .padding(.bottom, 21)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton().foregroundStyle(.white)
                }
                ToolbarItem {
                    NavigationLink {
                        AddAccountView()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
            }
            .customBackground()
        }
    }

    private var header: some View {
        HStack {
            Text("Accounts")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
    }

    private func accountRow(_ account: Account) -> some View {
        HStack {
            Image(account.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(account.name).whiteTitleText()
                Text(account.currentBalance,
                     format: .currency(code: account.currencyCode).presentation(.narrow)
                )
                .whiteTitleText()
            }

            Spacer()
        }
    }

    private func deleteAccounts(_ accountsToDelete: [Account]) {
        accountsToDelete.forEach(modelContext.delete)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete account(s):", error)
        }
    }
}

#Preview {
    AccountsView()
        .environment(UserSettings())
        .preferredColorScheme(.dark)
        .modelContainer(for: [Account.self, AccountTransaction.self], inMemory: true)
}
