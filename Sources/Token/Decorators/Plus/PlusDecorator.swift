import Foundation

internal struct PlusDecorator<Value: DecorableByPlus & TokenValue>: TokenDecorator {

    internal let other: Token<Value>

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value + other.resolve(for: theme)
    }
}

extension Token: DecorableByPlus where Value: DecorableByPlus & TokenValue {

    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.decorated(by: PlusDecorator(other: rhs))
    }
}
