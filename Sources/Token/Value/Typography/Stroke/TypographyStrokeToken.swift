#if canImport(UIKit1)
import UIKit

public typealias TypographyStrokeToken = Token<TypographyStrokeValue>

extension TypographyStrokeToken {

    public init(
        width: StrokeWidthToken,
        color: ColorToken? = nil
    ) {
        self = Token(traits: [width, color]) { theme in
            Value(
                width: width.resolve(for: theme),
                color: color?.resolve(for: theme)
            )
        }
    }
}

extension TypographyStrokeToken {

    public static var zero: Self {
        Self(width: .zero)
    }
}
#endif
