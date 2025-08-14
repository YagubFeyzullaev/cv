import Foundation

enum DateUtils {
	static func startOfMonth(for date: Date) -> Date {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year, .month], from: date)
		return calendar.date(from: components) ?? date
	}

	static func endOfMonth(for date: Date) -> Date {
		let calendar = Calendar.current
		if let range = calendar.range(of: .day, in: .month, for: date),
		   let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
			return calendar.date(byAdding: .day, value: range.count - 1, to: start) ?? date
		}
		return date
	}

	static func daysInCurrentMonth() -> [Date] {
		let calendar = Calendar.current
		let now = Date()
		let start = startOfMonth(for: now)
		let end = endOfMonth(for: now)
		var dates: [Date] = []
		var current = start
		while current <= end {
			dates.append(current)
			current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
		}
		return dates
	}

	static func startOfDay(_ date: Date) -> Date {
		Calendar.current.startOfDay(for: date)
	}

	static func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
		Calendar.current.isDate(lhs, inSameDayAs: rhs)
	}
}