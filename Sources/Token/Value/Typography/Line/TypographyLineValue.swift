#if canImport(UIKit)
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
}

extension TypographyLineValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            style: copy.style,
            color: copy.color
        )
    }

    public func color(_ color: ColorValue?) -> Self {
        changing { $0.color = color }
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
#endif
