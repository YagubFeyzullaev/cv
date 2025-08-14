import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
	@Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
	@Query private var accounts: [Account]

	private var totalBalance: Double {
		let base = accounts.reduce(0) { $0 + $1.startBalance }
		let delta = transactions.reduce(0) { $0 + $1.signedAmount }
		return base + delta
	}

	private var monthExpenses: Double {
		let now = Date()
		let start = DateUtils.startOfMonth(for: now)
		return transactions.filter { $0.isExpense && $0.date >= start }.reduce(0) { $0 + $1.amount }
	}

	private var monthIncome: Double {
		let now = Date()
		let start = DateUtils.startOfMonth(for: now)
		return transactions.filter { !$0.isExpense && $0.date >= start }.reduce(0) { $0 + $1.amount }
	}

	private var dailyExpenseSeries: [(Date, Double)] {
		let days = DateUtils.daysInCurrentMonth()
		return days.map { day in
			let sum = transactions.filter { $0.isExpense && DateUtils.isSameDay($0.date, day) }.reduce(0) { $0 + $1.amount }
			return (day, sum)
		}
	}

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 16) {
					HStack(spacing: 12) {
						StatCard(title: "Баланс", value: Formatters.currencyString(totalBalance), subtitle: nil)
						StatCard(title: "Доход (мес)", value: Formatters.currencyString(monthIncome), subtitle: nil)
					}
					StatCard(title: "Расход (мес)", value: Formatters.currencyString(monthExpenses), subtitle: nil)

					Chart(dailyExpenseSeries, id: \.0) { item in
						LineMark(x: .value("День", item.0), y: .value("Расход", item.1))
						AreaMark(x: .value("День", item.0), y: .value("Расход", item.1))
					}
					.chartYScale(domain: 0...max(1000, (dailyExpenseSeries.map { $0.1 }.max() ?? 0) * 1.2))
					.frame(height: 200)
					.padding(.top, 8)

					SectionHeader(title: "Последние транзакции")
					VStack(spacing: 0) {
						ForEach(transactions.prefix(6)) { t in
							TransactionRow(transaction: t)
							Divider()
						}
					}
				}
				.padding(16)
			}
			.navigationTitle("Главная")
		}
	}
}

private struct SectionHeader: View {
	let title: String
	var body: some View {
		HStack {
			Text(title).font(.headline)
			Spacer()
		}
	}
}

struct TransactionRow: View {
	let transaction: Transaction
	var body: some View {
		HStack(spacing: 12) {
			Text(categoryIcon(transaction.category))
			VStack(alignment: .leading, spacing: 2) {
				Text(transaction.category).font(.subheadline)
				Text(Formatters.fullDate.string(from: transaction.date)).font(.caption).foregroundStyle(.secondary)
			}
			Spacer()
			Text((transaction.isExpense ? "-" : "+") + Formatters.currencyString(transaction.amount))
				.font(.subheadline).foregroundStyle(transaction.isExpense ? .red : .green)
		}
		.padding(.vertical, 10)
	}

	private func categoryIcon(_ category: String) -> String {
		if let item = (CategoryProvider.expense + CategoryProvider.income).first(where: { $0.name == category }) {
			return item.icon
		}
		return "💠"
	}
}

#Preview {
	DashboardView()
		.modelContainer(for: [Transaction.self, Account.self])
}