#if canImport(UIKit1)
import UIKit

internal struct LineBreakModeDecorator<Value: DecorableByLineBreakMode>: TokenDecorator {

    internal let lineBreakMode: NSLineBreakMode?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.lineBreakMode(lineBreakMode)
    }
}

extension Token where Value: DecorableByLineBreakMode {

    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self {
        decorated(by: LineBreakModeDecorator(lineBreakMode: lineBreakMode))
    }
}
#endif
