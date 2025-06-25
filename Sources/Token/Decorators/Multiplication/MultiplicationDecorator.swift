import Foundation

internal struct MultiplicationDecorator<Value: DecorableByMultiplication>: TokenDecorator {

    internal let other: Token<Value>

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value * other.resolve(for: theme)
    }
}

extension Token: DecorableByMultiplication where Value: DecorableByMultiplication {

    public static func * (lhs: Self, rhs: Self) -> Self {
        lhs.decorated(by: MultiplicationDecorator(other: rhs))
    }
}
