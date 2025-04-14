import Foundation

internal struct DivisionDecorator<Value: DecorableByDivision & TokenValue>: TokenDecorator {

    internal let other: Token<Value>

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value / other.resolve(for: theme)
    }
}

extension Token where Value: DecorableByDivision & TokenValue {

    public static func / (lhs: Self, rhs: Self) -> Self {
        lhs.decorated(by: DivisionDecorator(other: rhs))
    }
}
