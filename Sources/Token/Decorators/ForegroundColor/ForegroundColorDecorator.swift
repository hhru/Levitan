import Foundation

internal struct ForegroundColorDecorator<Value: DecorableByForegroundColor>: TokenDecorator {

    internal let foregroundColor: ColorToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.foregroundColor(foregroundColor?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByForegroundColor {

    public func foregroundColor(_ foregroundColor: ColorToken?) -> Self {
        decorated(by: ForegroundColorDecorator(foregroundColor: foregroundColor))
    }
}
