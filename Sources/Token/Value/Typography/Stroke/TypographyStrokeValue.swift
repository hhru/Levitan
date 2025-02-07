#if canImport(UIKit)
import UIKit

public struct TypographyStrokeValue:
    TokenValue,
    Changeable,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    Sendable {

    public var width: CGFloat
    public var color: ColorValue?

    public init(
        width: CGFloat,
        color: ColorValue? = nil
    ) {
        self.width = width
        self.color = color
    }

    public init(integerLiteral width: Int) {
        self.init(width: CGFloat(width))
    }

    public init(floatLiteral width: Double) {
        self.init(width: CGFloat(width))
    }
}

extension TypographyStrokeValue: DecorableByColor {

    public func color(_ color: ColorValue?) -> Self {
        changing { $0.color = color }
    }
}

extension TypographyStrokeValue {

    public static var zero: Self {
        Self(width: .zero)
    }
}
#endif
