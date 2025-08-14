import SwiftUI
import SwiftData

struct TransactionsListView: View {
	@Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
	@Environment(\.modelContext) private var context
	@State private var showAdd = false
	@State private var filter: TransactionType? = nil

	private var filtered: [Transaction] {
		guard let filter else { return transactions }
		return transactions.filter { $0.type == filter }
	}

	var body: some View {
		NavigationStack {
			List {
				ForEach(filtered) { t in
					TransactionRow(transaction: t)
				}
				.onDelete(perform: delete)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Menu {
						Button("Все") { filter = nil }
						Divider()
						ForEach(TransactionType.allCases) { type in
							Button(type.rawValue) { filter = type }
						}
					} label: {
						Label(filter?.rawValue ?? "Фильтр", systemImage: "line.3.horizontal.decrease.circle")
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showAdd = true
					} label: {
						Image(systemName: "plus.circle.fill")
					}
				}
			}
			.navigationTitle("Транзакции")
		}
		.sheet(isPresented: $showAdd) {
			AddTransactionView()
		}
	}

	private func delete(at offsets: IndexSet) {
		for index in offsets {
			context.delete(filtered[index])
		}
		try? context.save()
	}
}

#Preview {
	TransactionsListView()
		.modelContainer(for: [Transaction.self, Account.self])
}