import Foundation
import SwiftData

enum Seeder {
	static func seedIfNeeded(context: ModelContext) {
		let fetch = FetchDescriptor<Account>()
		if let existing = try? context.fetch(fetch), existing.isEmpty == false {
			return
		}

		let cash = Account(name: "Наличные", type: .cash, startBalance: 2000)
		let card = Account(name: "Карта", type: .card, startBalance: 15000)
		let save = Account(name: "Сбережения", type: .savings, startBalance: 50000)
		context.insert(cash)
		context.insert(card)
		context.insert(save)

		let now = Date()
		let calendar = Calendar.current
		let sample: [(Double, TransactionType, String, Int, Account)] = [
			(450, .expense, "Кафе и рестораны", -1, card),
			(2200, .expense, "Продукты", -2, card),
			(1800, .expense, "Бензин", -3, cash),
			(120000, .income, "Зарплата", -10, save),
			(599, .expense, "Подписки", -5, card)
		]
		for item in sample {
			let date = calendar.date(byAdding: .day, value: item.3, to: now) ?? now
			let t = Transaction(amount: item.0, type: item.1, category: item.2, date: date, account: item.4)
			context.insert(t)
		}

		try? context.save()
	}
}