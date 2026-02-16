//
//  AddTransactionView.swift
//  Lumin
//
//  Created by James on 12/01/2026.
//

import SwiftData
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Account.name) private var accounts: [Account]

    @State private var amount: Decimal = 0
    @State private var title: String = ""
    @State private var date: Date = .now
    @State private var selectedAccountID: UUID?
    @State private var sign: TransactionSign = .minus
    @State private var errorMessage: String?

    enum TransactionSign: String, CaseIterable, Identifiable {
        case plus = "+"
        case minus = "−"
        var id: String { rawValue }
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var selectedAccount: Account? {
        guard let selectedAccountID else { return nil }
        return accounts.first(where: { $0.id == selectedAccountID })
    }

    private var currencyCode: String {
        selectedAccount?.currencyCode ?? "GBP"
    }

    enum CurrencySymbol {
        static func symbol(for code: String) -> String {
            let locale = Locale.availableIdentifiers
                .map(Locale.init)
                .first(where: { $0.currency?.identifier == code })

            return locale?.currencySymbol ?? code
        }
    }

    private var isValid: Bool {
        selectedAccount != nil &&
        !trimmedTitle.isEmpty &&
        amount > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    amountSection
                    detailsSection

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    addButton
                }
                .padding()
            }
            .customBackground()
            .onAppear(perform: bootstrapSelection)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Text("+ Add")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Transaction")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)
            Spacer()
        }
    }

    private var amountSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(CurrencySymbol.symbol(for: currencyCode))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)

                TextField(
                    "Amount",
                    value: $amount,
                    format: .number.precision(.fractionLength(2))
                )
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
                .keyboardType(.decimalPad)
            }
            .padding()
            .customContainer()
            .clipShape(Capsule())

            Picker("Type", selection: $sign) {
                ForEach(TransactionSign.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .customContainer()
            .clipShape(Capsule())
        }
    }

    private var detailsSection: some View {
        VStack(spacing: 16) {
            TextField("Title", text: $title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.75))
                .padding()
                .customContainer()
                .clipShape(Capsule())

            HStack {
                Text("Date")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.leading)

                Spacer()

                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .padding(.trailing)
                    .colorScheme(.dark)
            }
            .padding(.vertical, 8)
            .customContainer()
            .clipShape(RoundedRectangle(cornerRadius: 24))

            HStack {
                Text("Account")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.leading)

                Spacer()

                Picker("Account", selection: $selectedAccountID) {
                    ForEach(accounts) { account in
                        Text(account.name).tag(Optional(account.id))
                    }
                }
                .pickerStyle(.menu)
                .tint(.white.opacity(0.75))
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            .customContainer()
            .clipShape(Capsule())

            if accounts.isEmpty {
                Text("No accounts found. Create an account first.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.65))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var addButton: some View {
        Button("Add transaction") {
            addTransaction()
        }
        .disabled(!isValid)
        .font(.system(size: 20))
        .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
        .padding(21)
        .frame(maxWidth: .infinity)
        .background(isValid ? .white : .gray.opacity(0.4))
        .clipShape(Capsule())
    }

    private func bootstrapSelection() {

        if selectedAccountID == nil {
            selectedAccountID = accounts.first?.id
        }
    }

    private func addTransaction() {
        errorMessage = nil

        guard let account = selectedAccount else {
            errorMessage = "Please select an account."
            return
        }

        let cleanTitle = trimmedTitle
        guard !cleanTitle.isEmpty else {
            errorMessage = "Please enter a title."
            return
        }

        guard amount > 0 else {
            errorMessage = "Amount must be greater than zero."
            return
        }

        let signedAmount: Decimal = (sign == .minus) ? -amount : amount

        let newTransaction = AccountTransaction(
            id: UUID(),
            amount: signedAmount,
            date: date,
            title: cleanTitle,
            imageName: "TransactionImage3",
            account: account
        )

        modelContext.insert(newTransaction)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save transaction."
            print("Failed to save transaction:", error)
        }
    }
}

#Preview {
    AddTransactionView()
        .preferredColorScheme(.dark)
}
