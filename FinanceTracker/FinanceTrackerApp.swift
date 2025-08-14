import SwiftUI
import SwiftData

@main
struct FinanceTrackerApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                Transaction.self,
                Account.self
            ])
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Не удалось инициализировать хранилище данных: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}