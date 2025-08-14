import Foundation
import SwiftData

@Model
final class Account {
    var name: String
    var typeRaw: String
    var startBalance: Double
    var createdAt: Date

    init(name: String, type: AccountType, startBalance: Double = 0.0, createdAt: Date = Date()) {
        self.name = name
        self.typeRaw = type.rawValue
        self.startBalance = startBalance
        self.createdAt = createdAt
    }

    var type: AccountType {
        get { AccountType(rawValue: typeRaw) ?? .cash }
        set { typeRaw = newValue.rawValue }
    }

    var displayName: String { "\(type.emoji) \(name)" }
}