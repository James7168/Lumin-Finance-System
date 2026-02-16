//
//  AccountFilterView.swift
//  Lumin
//
//  Created by James on 14/01/2026.
//

import SwiftData
import SwiftUI

struct AccountFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Account.name) private var accounts: [Account]

    @Binding var filteredAccountIDs: Set<UUID>
    @State private var draftIDs: Set<UUID> = []

    private var allSelected: Bool {
        !accounts.isEmpty && draftIDs.count == accounts.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                header
                accountsList

                Button("Apply Filter") {
                    filteredAccountIDs = draftIDs
                    dismiss()
                }
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
                .padding(21)
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(Capsule())
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.01))
        }
        .onAppear(perform: loadDraft)
    }

    private var header: some View {
        HStack {
            Text("Account filter")
                .font(.title.bold())
                .foregroundStyle(.white)

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    if allSelected {
                        draftIDs.removeAll()
                    } else {
                        draftIDs = Set(accounts.map(\.id))
                    }
                }
            } label: {
                Text(allSelected ? "Clear" : "Select all")
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.3))
            .foregroundStyle(.white)
            .containerShape(Capsule())
        }
    }

    private var accountsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Accounts")
                .font(.title)
                .foregroundStyle(.white)

            VStack {
                ForEach(accounts) { account in
                    Button {
                        toggleSelection(for: account.id)
                    } label: {
                        row(account)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(.ultraThinMaterial.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    private func row(_ account: Account) -> some View {
        HStack {
            Image(systemName: draftIDs.contains(account.id) ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(.white)
                .opacity(draftIDs.contains(account.id) ? 1 : 0.3)

            Image(account.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .whiteBodyText().opacity(0.7)
                Text(account.currencyCode)
                    .whiteTitleText()
            }

            Spacer()

            Text(account.currentBalance,
                 format: .currency(code: account.currencyCode).presentation(.narrow)
            )
            .whiteTitleText()
        }
        .padding(17)
    }

    private func loadDraft() {
        draftIDs = filteredAccountIDs.isEmpty ? Set(accounts.map(\.id)) : filteredAccountIDs
    }

    private func toggleSelection(for id: UUID) {
        if draftIDs.contains(id) {
            draftIDs.remove(id)
        } else {
            draftIDs.insert(id)
        }
    }
}

#Preview {
    AccountFilterView(filteredAccountIDs: .constant([]))
        .preferredColorScheme(.dark)
        .modelContainer(for: [Account.self, AccountTransaction.self], inMemory: true)
}
