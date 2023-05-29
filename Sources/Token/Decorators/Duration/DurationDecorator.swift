import Foundation

internal struct DurationDecorator<Value: DecorableByDuration>: TokenDecorator {

    internal let duration: Double

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.duration(duration)
    }
}

extension Token where Value: DecorableByDuration {

    public func duration(_ duration: Double) -> Self {
        decorated(by: DurationDecorator(duration: duration))
    }
}
