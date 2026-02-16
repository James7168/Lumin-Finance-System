# Lumin - Deterministic Personal Finance & Account Modelling App

A model-driven personal finance system that enforces invariant-validated state transitions using SwiftUI and SwiftData.

Lumin models accounts and transactions as strongly typed domain entities, enforces invariants at construction time, and maintains deterministic financial state through explicit persistence and state transitions.

This project is designed with production-inspired separation of concerns, domain validation, explicit state management, and clear architectural boundaries between UI, data models, and business logic.

---

## Project Overview

**What it solves**:
Provides a structured system for modelling financial accounts and transactions, ensuring correctness of balances, state transitions, and multi-currency aggregation.

**Target scope**:
- Multi-account finance tracking.
- Transaction modelling.
- Balance computation.
- Multi-currency aggregation with explicit FX conversion.
- Persistent local storage using SwiftData.
- Explicit filtering and state-driven UI updates.

---

## Architecture Overview

The architecture intentionally separates UI rendering, domain models, state transitions, and persistence.

<img width="2060" height="695" alt="Lumin_Architecture" src="https://github.com/user-attachments/assets/589ee911-50c9-4baa-a290-d94efe67c05a" />

The system is designed as a controlled state model:
- Accounts maintain invariant-validated starting balances.
- Transactions mutate account state through explicit insertion.
- Current balances are derived properties, not stored values.
- State changes occur only through controlled mutation & persistence.

No implicit recalculation side effects occur outside explicit model updates.

---

## Data & State Model

### Domain-driven data structures

The system operates on SwiftData models:
- Account.
- AccountTransaction.
- Settings.

Validation is enforced at construction:
- Account name must not be empty.
- Starting balance must be ≥ 0.
- Currency codes are normalised and validated.
- Transaction amounts must be non-zero.
- Titles are trimmed and validated.

Derived financial values (ex: currentBalance) are computed properties rather than duplicated state.

This ensures correctness and prevents divergence between stored and displayed values.

---

## State Transitions

Financial state evolves only through:
- Insertion of an AccountTransaction.
- Mutation of Account.
- Explicit persistence via modelContext.save().

Reset functionality explicitly:
- Clears persistent state.
- Reinitialises demo data.
- Resets navigation state.

---

## Multi-Currency Handling

The system supports:
- Multiple accounts with different currency codes.
- Explicit FX conversion via a mapping function.
- Aggregation into a selected base currency.

FX conversion is implemented as a transformation:

amount -> source currency -> base currency

---

## Filtering Logic

Transaction filtering is implemented via:
- A TransactionFilter model.
- Explicit set membership over account identifiers.
- Fixed inclusion rules.

Filtering logic is independent of UI layout and does not mutate underlying financial state.

---

## Key Design Decisions

### Separation of concerns

- SwiftUI views render state only.
- Domain models enforce invariants.
- Financial computations are derived properties.
- FX conversion is isolated and pure.
- Filtering is encapsulated in its own observable model.

### Explicit validation

- Precondition checks.
- Input trimming.
- Currency normalisation.
- Non-zero transaction constraints.

### Financial modelling

- Balances are computed, not stored.
- Transactions are the single source of financial change.
- No duplicated or denormalised financial state exists.

### Numerical correctness

All financial values use Decimal to preserve accounting precision.

---

## Module Responsibilities

- Account.swift: Domain model & invariant enforcement.
- AccountTransaction.swift: Transaction entity & validation.
- UserSettings.swift: Application configuration. (base currency selection)
- DashboardView.swift: Aggregated wealth & recent transactions.
- AccountsView.swift: Account listing & deletion.
- TransactionsView.swift: Filtered transaction list & deletion.
- AccountFilterView.swift: Account filtering logic.
- AddAccountView.swift: Account creation.
- AddTransactionView.swift: Transaction creation.
- FocusedAccountView.swift: Account editing with constraint warnings.
- FocusedTransactionView.swift: Transaction editing.
- FX.swift: Currency transformation.
- DemoData.swift: Reproducible system reinitialisation.

---

## Limitations / Scope

This project is intentionally scoped to remain structurally focused:
- Local persistence only.
- Static FX rate mapping.
- No authentication layer.
- No background financial reconciliation.
- No concurrency optimisation beyond SwiftUI state model.

The focus is correctness of modelling and financial state transitions.

---

## Future Extensions

Lumin currently emphasises correctness of financial modelling, invariant enforcement, and deterministic state transitions. Several extensions could further formalise its architectural and computational foundations:

- **Immutable domain layer separation**  
  Introduce value-type domain models distinct from persistence-layer entities to further isolate business logic from storage concerns.

- **Predicate-based filtering composition**  
  Replace identifier-set filtering with composable predicate logic to enable richer query abstraction over transaction data.

- **Dynamic exchange rate modelling**  
  Extend the static FX mapping to support time-dependent rate series, allowing historically accurate multi-currency aggregation.

- **Concurrency-aware persistence handling**  
  Formalise state mutation under concurrent update scenarios to ensure correctness beyond the single-threaded UI model.

- **Formal invariant testing**  
  Introduce property-based or unit testing around financial invariants to verify correctness under edge-case conditions.

These extensions would transition the application from a structurally correct financial model to a more formally engineered financial system.

---

## How to Run

1. Open in Xcode.
2. Build & run on the simulator.
3. Initial demo data is injected if no persisted data exists.

---

## Conceptual Emphasis

This project treats a personal finance application not as a UI exercise, but as a small financial system:
- Explicit invariants.
- Controlled mutation.
- Derived state.
- Persistent correctness.
- Separation between modelling and presentation.

It demonstrates applied systems thinking within a stateful, user-facing application.
