import CoreGraphics

internal struct LetterSpacingDecorator<Value: DecorableByLetterSpacing>: TokenDecorator {

    internal let letterSpacing: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.letterSpacing(letterSpacing)
    }
}

extension Token where Value: DecorableByLetterSpacing {

    public func letterSpacing(_ letterSpacing: CGFloat?) -> Self {
        decorated(by: LetterSpacingDecorator(letterSpacing: letterSpacing))
    }
}
