import UIKit

internal struct AlignmentDecorator<Value: DecorableByAlignment>: TokenDecorator {

    internal let alignment: NSTextAlignment?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.alignment(alignment)
    }
}

extension Token where Value: DecorableByAlignment {

    public func alignment(_ alignment: NSTextAlignment?) -> Self {
        decorated(by: AlignmentDecorator(alignment: alignment))
    }
}
