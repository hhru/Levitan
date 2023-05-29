import Foundation

internal struct OpacityDecorator<Value: DecorableByOpacity>: TokenDecorator {

    internal let opacity: OpacityToken

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.opacity(opacity.resolve(for: theme))
    }
}

extension Token where Value: DecorableByOpacity {

    public func opacity(_ opacity: OpacityToken) -> Token<Value> {
        decorated(by: OpacityDecorator(opacity: opacity))
    }
}
