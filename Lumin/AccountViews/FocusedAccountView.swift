//
//  FocusedAccountView.swift
//  Lumin
//
//  Created by James on 16/01/2026.
//

import SwiftData
import SwiftUI

struct FocusedAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let account: Account

    @State private var draftName: String
    @State private var draftStartingBalance: Decimal
    @State private var draftCurrency: String

    @State private var errorMessage: String?
    @State private var showingCurrencyWarning = false
    @State private var showingBalanceWarning = false

    init(account: Account) {
        self.account = account
        _draftName = .init(initialValue: account.name)
        _draftStartingBalance = .init(initialValue: account.startingBalance)
        _draftCurrency = .init(initialValue: account.currencyCode)
    }

    private var trimmedName: String {
        draftName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var hasTransactions: Bool {
        !account.transactions.isEmpty
    }

    private var isValid: Bool {
        !trimmedName.isEmpty && draftStartingBalance > 0
    }

    private var hasChanges: Bool {
        trimmedName != account.name ||
        draftStartingBalance != account.startingBalance ||
        draftCurrency != account.currencyCode
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    balanceSection
                    nameSection

                    if hasTransactions {
                        Text("This account has existing transactions. Editing starting balance or currency can make historical balances misleading.")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.65))
                            .padding(.top, 3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    saveButton
                }
                .padding()
            }
            .customBackground()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
            .alert("Change currency?", isPresented: $showingCurrencyWarning) {
                Button("Change", role: .destructive) {
                    saveEdits()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This account already has transactions. Changing the currency will not convert existing amounts and may make totals incorrect.")
            }
            .alert("Change starting balance?", isPresented: $showingBalanceWarning) {
                Button("Change", role: .destructive) {
                    saveEdits()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This account already has transactions. Changing the starting balance can rewrite historical balances.")
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Edit")
                .font(.largeTitle)
                .foregroundStyle(.white)

            Text("Account")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)

            Spacer()
        }
    }

    private var balanceSection: some View {
        VStack(spacing: 16) {
            HStack {
                TextField(
                    "Starting Balance",
                    value: $draftStartingBalance,
                    format: .number.precision(.fractionLength(2))
                )
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
                .keyboardType(.decimalPad)
            }
            .padding()
            .customContainer()
            .clipShape(Capsule())
            .opacity(hasTransactions ? 0.7 : 1.0)

            Picker("Account Currency", selection: $draftCurrency) {
                Text("GBP").tag("GBP")
                Text("USD").tag("USD")
                Text("EUR").tag("EUR")
            }
            .pickerStyle(.segmented)
            .opacity(hasTransactions ? 0.7 : 1.0)

            if hasTransactions {
                Text("Tip: If you want to correct balance, consider adding a one-off adjustment transaction instead of editing starting balance.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var nameSection: some View {
        TextField("Account Name", text: $draftName)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white.opacity(0.75))
            .padding()
            .customContainer()
            .clipShape(Capsule())
    }

    private var saveButton: some View {
        Button("Save") {
            attemptSave()
        }
        .disabled(!isValid || !hasChanges)
        .font(.system(size: 20))
        .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
        .padding(21)
        .frame(maxWidth: .infinity)
        .background((isValid && hasChanges) ? .white : .gray.opacity(0.4))
        .clipShape(Capsule())
    }

    private func attemptSave() {
        errorMessage = nil

        guard isValid else {
            errorMessage = "Please enter a valid name and a positive starting balance."
            return
        }

        if hasTransactions && draftCurrency != account.currencyCode {
            showingCurrencyWarning = true
            return
        }

        if hasTransactions && draftStartingBalance != account.startingBalance {
            showingBalanceWarning = true
            return
        }

        saveEdits()
    }

    private func saveEdits() {
        errorMessage = nil

        account.name = trimmedName
        account.startingBalance = draftStartingBalance
        account.currencyCode = draftCurrency

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save changes."
            print("Failed to save account edits:", error)
        }
    }
}

#Preview{
    
}
