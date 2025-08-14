import Foundation

enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case expense = "Расход"
    case income = "Доход"

    var id: String { rawValue }

    var sign: Double { self == .expense ? -1.0 : 1.0 }
}

enum AccountType: String, Codable, CaseIterable, Identifiable {
    case cash = "Наличные"
    case card = "Карта"
    case savings = "Сбережения"
    case deposit = "Вклад"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .cash: return "💵"
        case .card: return "💳"
        case .savings: return "🏦"
        case .deposit: return "📈"
        }
    }
}

struct Category: Identifiable, Hashable, Codable {
    var id: String { name }
    let name: String
    let icon: String
}

enum CategoryProvider {
    static let expense: [Category] = [
        .init(name: "Кафе и рестораны", icon: "🍽️"),
        .init(name: "Бензин", icon: "⛽"),
        .init(name: "Продукты", icon: "🛒"),
        .init(name: "Транспорт", icon: "🚌"),
        .init(name: "Дом", icon: "🏠"),
        .init(name: "Развлечения", icon: "🎮"),
        .init(name: "Здоровье", icon: "🏥"),
        .init(name: "Одежда", icon: "👕"),
        .init(name: "Подписки", icon: "🔔"),
        .init(name: "Путешествия", icon: "✈️"),
        .init(name: "Прочее", icon: "🧩")
    ]

    static let income: [Category] = [
        .init(name: "Зарплата", icon: "💼"),
        .init(name: "Подарки", icon: "🎁"),
        .init(name: "Проценты", icon: "📈"),
        .init(name: "Фриланс", icon: "🧑‍💻")
    ]
}