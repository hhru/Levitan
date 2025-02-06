#if canImport(UIKit)
import Foundation

internal struct FontScaleDecorator<Value: DecorableByFontScale>: TokenDecorator {

    internal let fontScale: FontScaleToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.fontScale(fontScale?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByFontScale {

    public func fontScale(_ fontScale: FontScaleToken?) -> Self {
        decorated(by: FontScaleDecorator(fontScale: fontScale))
    }
}
#endif
