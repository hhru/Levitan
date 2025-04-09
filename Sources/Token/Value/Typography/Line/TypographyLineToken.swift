#if canImport(UIKit)
import UIKit

public typealias TypographyLineToken = Token<TypographyLineValue>

extension TypographyLineToken {

    public init(
        style: NSUnderlineStyle,
        color: ColorToken? = nil
    ) {
        self = Token(traits: [style, color]) { theme in
            Value(
                style: style,
                color: color?.resolve(for: theme)
            )
        }
    }
}

extension TypographyLineToken {

    public static var single: Self {
        Self(style: .single)
    }

    public static func single(color: ColorToken?) -> Self {
        Self(
            style: .single,
            color: color
        )
    }
}
#endif
