import Foundation

internal struct PlusDecorator<Value: DecorableByPlus>: TokenDecorator {

    internal let other: Token<Value>

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value + other.resolve(for: theme)
    }
}

extension Token: DecorableByPlus where Value: DecorableByPlus {

    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.decorated(by: PlusDecorator(other: rhs))
    }
}
