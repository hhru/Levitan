#if canImport(UIKit1)
import Foundation

internal struct StrikethroughDecorator<Value: DecorableByStrikethrough>: TokenDecorator {

    internal let strikethrough: TypographyLineToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.strikethrough(strikethrough?.resolve(for: theme))
    }
}

extension Token where Value: DecorableByStrikethrough {

    public func strikethrough(_ strikethrough: TypographyLineToken? = .single) -> Self {
        decorated(by: StrikethroughDecorator(strikethrough: strikethrough))
    }
}
#endif
