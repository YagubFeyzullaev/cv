import SwiftUI
import SwiftData

struct AccountsView: View {
	@Query private var accounts: [Account]
	@Environment(\.modelContext) private var context
	@State private var showAdd = false

	private func accountBalance(_ account: Account, transactions: [Transaction]) -> Double {
		let delta = transactions.filter { $0.account === account }.reduce(0) { $0 + $1.signedAmount }
		return account.startBalance + delta
	}

	var body: some View {
		NavigationStack {
			List {
				Section("Счета") {
					ForEach(accounts) { acc in
						AccountRow(account: acc)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button { showAdd = true } label: { Image(systemName: "plus.circle.fill") }
				}
			}
			.navigationTitle("Счета")
		}
		.sheet(isPresented: $showAdd) { AddAccountView() }
	}
}

private struct AccountRow: View {
	@Query private var transactions: [Transaction]
	let account: Account
	var body: some View {
		let delta = transactions.filter { $0.account === account }.reduce(0) { $0 + $1.signedAmount }
		let balance = account.startBalance + delta
		HStack {
			Text(account.type.emoji)
			VStack(alignment: .leading) {
				Text(account.name)
				Text(account.type.rawValue).font(.caption).foregroundStyle(.secondary)
			}
			Spacer()
			Text(Formatters.currencyString(balance)).font(.subheadline)
		}
	}
}

private struct AddAccountView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	@State private var name: String = ""
	@State private var type: AccountType = .cash
	@State private var startBalanceText: String = "0"

	var body: some View {
		NavigationStack {
			Form {
				TextField("Название счета", text: $name)
				Picker("Тип", selection: $type) {
					ForEach(AccountType.allCases) { t in Text(t.rawValue).tag(t) }
				}
				TextField("Начальный баланс", text: $startBalanceText)
					.keyboardType(.decimalPad)
			}
			.navigationTitle("Новый счет")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } }
				ToolbarItem(placement: .confirmationAction) {
					Button("Сохранить") { save() }.disabled(name.isEmpty)
				}
			}
		}
	}

	private var startBalance: Double { Double(startBalanceText.replacingOccurrences(of: ",", with: ".")) ?? 0 }
	private func save() {
		let acc = Account(name: name, type: type, startBalance: startBalance)
		context.insert(acc)
		try? context.save()
		dismiss()
	}
}

#Preview {
	AccountsView()
		.modelContainer(for: [Transaction.self, Account.self])
}