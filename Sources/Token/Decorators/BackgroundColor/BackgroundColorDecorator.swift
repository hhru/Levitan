import Foundation

internal struct BackgroundColorDecorator<Value: DecorableByBackgroundColor>: TokenDecorator {

    internal let backgroundColor: ColorToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.backgroundColor(backgroundColor?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByBackgroundColor {

    public func backgroundColor(_ backgroundColor: ColorToken?) -> Self {
        decorated(by: BackgroundColorDecorator(backgroundColor: backgroundColor))
    }
}
