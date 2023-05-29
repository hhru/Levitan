import UIKit

public struct TypographyLineValue:
    TokenValue,
    DecorableByColor,
    Sendable {

    public let style: NSUnderlineStyle
    public let color: ColorValue?

    public init(
        style: NSUnderlineStyle,
        color: ColorValue? = nil
    ) {
        self.style = style
        self.color = color
    }

    public func color(_ color: ColorValue?) -> Self {
        Self(style: style, color: color)
    }
}

extension TypographyLineValue {

    public static var single: Self {
        Self(style: .single)
    }

    public static func single(color: ColorValue?) -> Self {
        Self(
            style: .single,
            color: color
        )
    }
}
