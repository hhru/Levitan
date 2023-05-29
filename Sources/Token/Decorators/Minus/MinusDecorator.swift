import Foundation

internal struct MinusDecorator<Value: DecorableByMinus>: TokenDecorator {

    internal let other: Token<Value>

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value - other.resolve(for: theme)
    }
}

extension Token: DecorableByMinus where Value: DecorableByMinus {

    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.decorated(by: MinusDecorator(other: rhs))
    }
}
