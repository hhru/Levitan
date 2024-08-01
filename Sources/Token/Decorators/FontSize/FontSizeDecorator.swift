import Foundation

internal struct FontSizeDecorator<Value: DecorableByFontSize>: TokenDecorator {

    internal let fontSize: FontSizeToken

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.fontSize(fontSize.resolve(for: theme))
    }
}

extension Token where Value: DecorableByFontSize {

    public func fontSize(_ fontSize: FontSizeToken) -> Self {
        decorated(by: FontSizeDecorator(fontSize: fontSize))
    }
}
