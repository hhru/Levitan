import Foundation

internal struct NilCoalescingDecorator<Value>: TokenDecorator {

    internal let defaultValue: Token<Value>

    internal func decorate(_ value: Value?, theme: TokenTheme) -> Value {
        value ?? defaultValue.resolve(for: theme)
    }
}

extension Token {

    public static func ?? (
        optional: Token<Value?>,
        defaultValue: @autoclosure () throws -> Token<Value>
    ) rethrows -> Token<Value> {
        optional.decorated(by: NilCoalescingDecorator(defaultValue: try defaultValue()))
    }
}
