import UIKit

public struct TypographyStrokeValue:
    TokenValue,
    DecorableByColor,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    Sendable {

    public let width: CGFloat
    public let color: ColorValue?

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

    public func color(_ color: ColorValue?) -> Self {
        Self(
            width: width,
            color: color
        )
    }
}

extension TypographyStrokeValue {

    public static var zero: Self {
        Self(width: .zero)
    }
}
