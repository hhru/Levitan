import Foundation

internal struct NegationDecorator<Value: DecorableByNegation>: TokenDecorator {

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        -value
    }
}

extension Token: DecorableByNegation where Value: DecorableByNegation {

    public static prefix func - (value: Self) -> Self {
        value.decorated(by: NegationDecorator())
    }
}
