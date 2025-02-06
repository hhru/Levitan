#if canImport(UIKit1)
import Foundation

internal struct StrokeDecorator<Value: DecorableByStroke>: TokenDecorator {

    internal let stroke: TypographyStrokeToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.stroke(stroke?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByStroke {

    public func stroke(_ stroke: TypographyStrokeToken? = 1.0) -> Self {
        decorated(by: StrokeDecorator(stroke: stroke))
    }
}
#endif
