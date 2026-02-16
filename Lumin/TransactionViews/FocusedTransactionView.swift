//
//  FocusedTransactionView.swift
//  Lumin
//
//  Created by James on 12/01/2026.
//

import SwiftData
import SwiftUI

struct FocusedTransactionView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Account.name) private var accounts: [Account]

    let transaction: AccountTransaction

    enum TransactionSign: String, CaseIterable, Identifiable {
        case plus = "+"
        case minus = "−"
        var id: String { rawValue }
    }

    @State private var draftTitle: String
    @State private var draftDate: Date
    @State private var draftAmount: Decimal
    @State private var draftAccount: Account
    @State private var sign: TransactionSign
    @State private var errorMessage: String?

    init(transaction: AccountTransaction) {
        self.transaction = transaction

        let isNegative = transaction.amount < 0

        _draftTitle = State(initialValue: transaction.title)
        _draftDate = State(initialValue: transaction.date)
        _draftAmount = State(initialValue: abs(transaction.amount))
        _draftAccount = State(initialValue: transaction.account)
        _sign = State(initialValue: isNegative ? .minus : .plus)
    }

    private var trimmedTitle: String {
        draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var signedAmount: Decimal {
        sign == .minus ? -draftAmount : draftAmount
    }

    private var isValid: Bool {
        !trimmedTitle.isEmpty && draftAmount > 0
    }

    private var hasChanges: Bool {
        trimmedTitle != transaction.title ||
        draftDate != transaction.date ||
        signedAmount != transaction.amount ||
        draftAccount.id != transaction.account.id
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    amountSection
                    titleSection
                    dateSection
                    accountSection

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
        }
    }

    private var header: some View {
        HStack {
            Text("Edit")
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
                Text(CurrencySymbol.symbol(for: draftAccount.currencyCode))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)

                TextField(
                    "Amount",
                    value: $draftAmount,
                    format: .number.precision(.fractionLength(2))
                )
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
                .keyboardType(.decimalPad)
                .onChange(of: draftAmount) { _, newValue in
                    if newValue < 0 { draftAmount = abs(newValue) }
                }
            }
            .padding()
            .customContainer()
            .clipShape(Capsule())

            Picker("Type", selection: $sign) {
                Text("+").tag(TransactionSign.plus)
                Text("−").tag(TransactionSign.minus)
            }
            .pickerStyle(.segmented)
            .padding()
            .customContainer()
            .clipShape(Capsule())
        }
    }

    private var titleSection: some View {
        TextField("Title", text: $draftTitle)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white.opacity(0.75))
            .padding()
            .customContainer()
            .clipShape(Capsule())
    }

    private var dateSection: some View {
        HStack {
            Text("Date")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.75))

            Spacer()

            DatePicker("", selection: $draftDate, displayedComponents: .date)
                .labelsHidden()
                .colorScheme(.dark)
        }
        .padding()
        .customContainer()
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var accountSection: some View {
        HStack {
            Text("Account")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.75))

            Spacer()

            Picker("Account", selection: $draftAccount) {
                ForEach(accounts) { account in
                    Text(account.name).tag(account)
                }
            }
            .pickerStyle(.menu)
            .tint(.white.opacity(0.75))
        }
        .padding()
        .customContainer()
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var saveButton: some View {
        Button("Save") {
            saveChanges()
        }
        .disabled(!isValid || !hasChanges)
        .font(.system(size: 20))
        .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
        .padding(21)
        .frame(maxWidth: .infinity)
        .background((isValid && hasChanges) ? .white : .gray.opacity(0.4))
        .clipShape(Capsule())
    }

    private func saveChanges() {
        errorMessage = nil

        guard isValid else {
            errorMessage = "Please enter a valid title and amount."
            return
        }

        transaction.title = trimmedTitle
        transaction.date = draftDate
        transaction.amount = signedAmount
        transaction.account = draftAccount

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save changes."
        }
    }
}

enum CurrencySymbol {
    static func symbol(for code: String) -> String {
        Locale.availableIdentifiers
            .map(Locale.init)
            .first(where: { $0.currency?.identifier == code })?
            .currencySymbol ?? code
    }
}

#Preview {
    AddTransactionView()
        .preferredColorScheme(.dark)
}
