import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
	@Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
	@State private var selectedMonthOffset: Int = 0

	private var currentMonth: Date {
		Calendar.current.date(byAdding: .month, value: selectedMonthOffset, to: Date()) ?? Date()
	}

	private var monthTransactions: [Transaction] {
		let start = DateUtils.startOfMonth(for: currentMonth)
		let end = DateUtils.endOfMonth(for: currentMonth)
		return transactions.filter { $0.date >= start && $0.date <= end }
	}

	private var expenseByCategory: [(String, Double)] {
		let groups = Dictionary(grouping: monthTransactions.filter { $0.isExpense }) { $0.category }
		return groups.map { (key, value) in
			(key, value.reduce(0) { $0 + $1.amount })
		}.sorted { $0.1 > $1.1 }
	}

	private var monthlyExpenseBars: [(Date, Double)] {
		let months = (-5...0).compactMap { Calendar.current.date(byAdding: .month, value: $0, to: Date()) }
		return months.map { month in
			let start = DateUtils.startOfMonth(for: month)
			let end = DateUtils.endOfMonth(for: month)
			let sum = transactions.filter { $0.isExpense && $0.date >= start && $0.date <= end }.reduce(0) { $0 + $1.amount }
			return (month, sum)
		}
	}

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text("Расходы по категориям (") + Text(Formatters.monthShort.string(from: currentMonth)) + Text(")")
					Chart(expenseByCategory, id: \.0) { item in
						SectorMark(angle: .value("Сумма", item.1), innerRadius: .ratio(0.55))
							.foregroundStyle(by: .value("Категория", item.0))
					}
					.frame(height: 240)

					Text("Расходы по месяцам")
					Chart(monthlyExpenseBars, id: \.0) { item in
						BarMark(x: .value("Месяц", item.0, unit: .month), y: .value("Сумма", item.1))
					}
					.frame(height: 200)

					HStack {
						Button("<") { selectedMonthOffset -= 1 }
						Button(">") { selectedMonthOffset += 1 }
					}
				}
				.padding(16)
			}
			.navigationTitle("Аналитика")
		}
	}
}

#Preview {
	AnalyticsView()
		.modelContainer(for: [Transaction.self, Account.self])
}