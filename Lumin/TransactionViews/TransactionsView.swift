//
//  TransactionsView.swift
//  Lumin
//
//  Created by James on 11/01/2026.
//

import SwiftData
import SwiftUI

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var accounts: [Account]

    @Query(sort: \AccountTransaction.date, order: .reverse)
    private var transactions: [AccountTransaction]

    @State private var transactionFilter = TransactionFilter()
    @State private var showingAccountFilter = false
    @State private var errorMessage: String?

    private var filteredTransactions: [AccountTransaction] {
        transactions.filter { transactionFilter.includes($0.account.id) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                header

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                List {
                    ForEach(filteredTransactions) { transaction in
                        NavigationLink {
                            FocusedTransactionView(transaction: transaction)
                        } label: {
                            row(transaction)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteTransactions([transaction])
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
                        let toDelete = indexSet.map { filteredTransactions[$0] }
                        deleteTransactions(toDelete)
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
                    EditButton()
                        .foregroundStyle(.white)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddTransactionView()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAccountFilter = true
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                    .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $showingAccountFilter) {
                AccountFilterView(filteredAccountIDs: $transactionFilter.selectedAccountIDs)
                    .presentationDetents([.height(550)])
                    .presentationDragIndicator(.visible)
            }
            .customBackground()
        }
    }

    private var header: some View {
        HStack {
            Text("Transactions")
                .font(.largeTitle.bold().italic())
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
    }

    private func row(_ transaction: AccountTransaction) -> some View {
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

            Text(
                transaction.amount,
                format: .currency(code: transaction.account.currencyCode).presentation(.narrow)
            )
            .whiteTitleText()
        }
    }

    private func deleteTransactions(_ transactions: [AccountTransaction]) {
        errorMessage = nil
        transactions.forEach(modelContext.delete)

        do {
            try modelContext.save()
        } catch {
            errorMessage = "Delete failed. Please try again."
        }
    }
}

#Preview {
    TransactionsView()
        .preferredColorScheme(.dark)
}
