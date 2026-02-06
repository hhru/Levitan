import Foundation

extension DateFormatter {

    static let hoursMinutes: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale = .current
        formatter.dateFormat = "HH:mm"
        formatter.isLenient = true

        return formatter
    }()

    static let dayTextualMonthYear: DateFormatter = {
        let formatter = DateFormatter()

        formatter.locale = .current
        formatter.dateFormat = "d'\u{00a0}'MMMM'\u{00a0}'yyyy"
        formatter.isLenient = true

        return formatter
    }()
}
