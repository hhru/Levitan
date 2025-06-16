#if canImport(UIKit)
import Foundation

internal struct UnderlineDecorator<Value: DecorableByUnderline>: TokenDecorator {

    internal let underline: TypographyLineToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.underline(underline?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByUnderline {

    public func underline(_ underline: TypographyLineToken? = .single) -> Self {
        decorated(by: UnderlineDecorator(underline: underline))
    }
}
#endif
