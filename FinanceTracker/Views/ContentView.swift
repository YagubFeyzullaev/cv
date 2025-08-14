import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var context
	@State private var seeded = false

	var body: some View {
		TabView {
			DashboardView()
				.tabItem { Label("Главная", systemImage: "chart.line.uptrend.xyaxis") }

			TransactionsListView()
				.tabItem { Label("Транзакции", systemImage: "list.bullet") }

			AnalyticsView()
				.tabItem { Label("Аналитика", systemImage: "chart.pie") }

			AccountsView()
				.tabItem { Label("Счета", systemImage: "creditcard") }
		}
		.onAppear {
			if seeded == false {
				Seeder.seedIfNeeded(context: context)
				seeded = true
			}
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: [Transaction.self, Account.self])
}