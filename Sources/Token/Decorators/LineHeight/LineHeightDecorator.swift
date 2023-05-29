import Foundation

internal struct LineHeightDecorator<Value: DecorableByLineHeight>: TokenDecorator {

    internal let lineHeight: CGFloat?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.lineHeight(lineHeight)
    }
}

extension Token where Value: DecorableByLineHeight {

    public func lineHeight(_ lineHeight: CGFloat?) -> Self {
        decorated(by: LineHeightDecorator(lineHeight: lineHeight))
    }
}
