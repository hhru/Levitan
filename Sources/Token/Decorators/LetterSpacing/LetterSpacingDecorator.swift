import Foundation

internal struct LetterSpacingDecorator<Value: DecorableByLetterSpacing>: TokenDecorator {

    internal let letterSpacing: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.letterSpacing(letterSpacing)
    }
}

extension Token where Value: DecorableByLetterSpacing {

    public func letterSpacing(_ letterSpacing: CGFloat?) -> Token<Value> {
        decorated(by: LetterSpacingDecorator(letterSpacing: letterSpacing))
    }
}
