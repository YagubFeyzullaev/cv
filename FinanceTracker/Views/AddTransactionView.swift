import SwiftUI
import SwiftData

struct AddTransactionView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	@Query private var accounts: [Account]

	@State private var amountText: String = ""
	@State private var type: TransactionType = .expense
	@State private var category: String = CategoryProvider.expense.first?.name ?? "Прочее"
	@State private var date: Date = Date()
	@State private var note: String = ""
	@State private var account: Account?

	var body: some View {
		NavigationStack {
			Form {
				Section("Сумма") {
					TextField("0,00", text: $amountText)
						.keyboardType(.decimalPad)
				}
				Section("Тип") {
					Picker("Тип", selection: $type) {
						ForEach(TransactionType.allCases) { t in Text(t.rawValue).tag(t) }
					}
					.pickerStyle(.segmented)
				}
				Section("Категория") {
					Picker("Категория", selection: $category) {
						ForEach(categories, id: \.name) { c in
							Text("\(c.icon) \(c.name)").tag(c.name)
						}
					}
				}
				Section("Счет") {
					Picker("Счет", selection: $account) {
						Text("Без счета").tag(Account?.none)
						ForEach(accounts) { acc in
							Text(acc.displayName).tag(Account?.some(acc))
						}
					}
				}
				Section("Дата") {
					DatePicker("Дата", selection: $date, displayedComponents: .date)
				}
				Section("Заметка") {
					TextField("Опционально", text: $note)
				}
			}
			.navigationTitle("Новая транзакция")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Отмена") { dismiss() }
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Сохранить") { save() }.disabled(amount == nil || amount == 0)
				}
			}
		}
	}

	private var amount: Double? {
		Double(amountText.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: ""))
	}

	private var categories: [Category] {
		type == .expense ? CategoryProvider.expense : CategoryProvider.income
	}

	private func save() {
		guard let amount else { return }
		let tx = Transaction(amount: amount, type: type, category: category, date: date, note: note.isEmpty ? nil : note, account: account)
		context.insert(tx)
		try? context.save()
		dismiss()
	}
}

#Preview {
	AddTransactionView()
		.modelContainer(for: [Transaction.self, Account.self])
}