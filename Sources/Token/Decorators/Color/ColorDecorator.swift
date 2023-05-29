import Foundation

internal struct ColorDecorator<Value: DecorableByColor>: TokenDecorator {

    internal let color: ColorToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.color(color?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByColor {

    public func color(_ color: ColorToken?) -> Self {
        decorated(by: ColorDecorator(color: color))
    }
}
