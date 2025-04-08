import CoreGraphics
import Foundation

internal struct AlphaDecorator<Value: DecorableByAlpha>: TokenDecorator {

    internal let alpha: CGFloat

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.alpha(alpha)
    }
}

extension Token where Value: DecorableByAlpha {

    public func alpha(_ alpha: CGFloat) -> Self {
        decorated(by: AlphaDecorator(alpha: alpha))
    }
}
