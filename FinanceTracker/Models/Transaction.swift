import Foundation
import SwiftData

@Model
final class Transaction {
    var amount: Double
    var typeRaw: String
    var category: String
    var date: Date
    var note: String?
    var createdAt: Date
    var account: Account?

    init(amount: Double, type: TransactionType, category: String, date: Date = Date(), note: String? = nil, account: Account? = nil) {
        self.amount = amount
        self.typeRaw = type.rawValue
        self.category = category
        self.date = date
        self.note = note
        self.account = account
        self.createdAt = Date()
    }

    var type: TransactionType {
        get { TransactionType(rawValue: typeRaw) ?? .expense }
        set { typeRaw = newValue.rawValue }
    }

    var signedAmount: Double { amount * type.sign }

    var isExpense: Bool { type == .expense }
}