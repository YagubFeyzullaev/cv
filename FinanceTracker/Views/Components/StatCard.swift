import SwiftUI

struct StatCard: View {
	let title: String
	let value: String
	let subtitle: String?

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title).font(.caption).foregroundStyle(.secondary)
			Text(value).font(.title2).fontWeight(.semibold)
			if let subtitle { Text(subtitle).font(.caption2).foregroundStyle(.secondary) }
		}
		.padding(12)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
	}
}

#Preview {
	StatCard(title: "Баланс", value: "120 000 ₽", subtitle: "+ 8 500 ₽ за месяц")
		.padding()
		.background(Color(.systemBackground))
}