import Foundation

enum Formatters {
    static let currency: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = Locale(identifier: "ru_RU")
        nf.maximumFractionDigits = 2
        return nf
    }()

    static func currencyString(_ value: Double) -> String {
        let number = NSNumber(value: value)
        return currency.string(from: number) ?? "\(value) ₽"
    }

    static let dayShort: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMM"
        return df
    }()

    static let monthShort: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "LLL yy"
        return df
    }()

    static let fullDate: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateStyle = .medium
        return df
    }()
}