//
//  AddAccountView.swift
//  Lumin
//
//  Created by James on 12/01/2026.
//

import SwiftData
import SwiftUI

struct AddAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var startingBalance: Decimal = 0
    @State private var accountCurrency: String = "GBP"
    @State private var errorMessage: String?
    
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isValid: Bool {
        !trimmedName.isEmpty && startingBalance > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    balanceInputSection
                    nameInputSection

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                    addButton
                }
                .padding()
            }
            .customBackground()
        }
    }
    
    private var header: some View {
        HStack {
            Text("+ Add")
                .font(.largeTitle)
                .foregroundStyle(.white)

            Text("Account")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)

            Spacer()
        }
    }

    private var balanceInputSection: some View {
        VStack(spacing: 16) {
            HStack {
                TextField(
                    "Initial Balance",
                    value: $startingBalance,
                    format: .number.precision(.fractionLength(2))
                )
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
                .keyboardType(.decimalPad)
            }
            .padding()
            .customContainer()
            .clipShape(Capsule())

            Picker("Account Currency", selection: $accountCurrency) {
                Text("GBP").tag("GBP")
                Text("USD").tag("USD")
                Text("EUR").tag("EUR")
            }
            .pickerStyle(.segmented)
        }
    }

    private var nameInputSection: some View {
        TextField("Account Name", text: $name)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white.opacity(0.75))
            .padding()
            .customContainer()
            .clipShape(Capsule())
    }

    private var addButton: some View {
        Button("Add Account") {
            addAccount()
        }
        .disabled(!isValid)
        .font(.system(size: 20))
        .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
        .padding(21)
        .frame(maxWidth: .infinity)
        .background(isValid ? .white : .gray.opacity(0.4))
        .clipShape(Capsule())
    }
    
    private func addAccount() {
        errorMessage = nil

        guard isValid else {
            errorMessage = "Please enter a valid name and positive balance."
            return
        }

        let newAccount = Account(
            id: UUID(),
            name: trimmedName,
            currencyCode: accountCurrency,
            startingBalance: startingBalance,
            imageName: "GradientH",
            transactions: []
        )

        modelContext.insert(newAccount)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save account."
            print("Failed to save account:", error)
        }
    }
}

#Preview {
    
}
