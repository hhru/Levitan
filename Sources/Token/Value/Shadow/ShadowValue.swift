import CoreGraphics
import Foundation

public struct ShadowValue:
    TokenValue,
    Changeable,
    Sendable {

    public var type: ShadowType
    public var color: ColorValue?
    public var offset: CGSize
    public var radius: CGFloat
    public var spread: CGFloat

    public var isSpreaded: Bool {
        abs(spread) > .leastNonzeroMagnitude
    }

    public var isClear: Bool {
        color?.isClear ?? true
    }

    public init(
        type: ShadowType,
        color: ColorValue?,
        offset: CGSize,
        radius: CGFloat,
        spread: CGFloat = .zero
    ) {
        self.type = type
        self.color = color
        self.offset = offset
        self.radius = radius
        self.spread = spread
    }

    public init(
        type: ShadowType,
        color: ColorValue?,
        offset: CGSize,
        blur: CGFloat,
        spread: CGFloat = .zero
    ) {
        self.init(
            type: type,
            color: color,
            offset: offset,
            radius: blur * 0.5,
            spread: spread
        )
    }
}

extension ShadowValue: DecorableByColor {

    public func color(_ color: ColorValue?) -> Self {
        changing { $0.color = color }
    }
}

extension ShadowValue {

    public static var clear: Self {
        Self(
            type: .drop,
            color: nil,
            offset: .zero,
            radius: .zero
        )
    }

    public static func drop(
        color: ColorValue?,
        offset: CGSize,
        radius: CGFloat,
        spread: CGFloat = .zero
    ) -> Self {
        Self(
            type: .drop,
            color: color,
            offset: offset,
            radius: radius,
            spread: spread
        )
    }

    public static func drop(
        color: ColorValue?,
        offset: CGSize,
        blur: CGFloat,
        spread: CGFloat = .zero
    ) -> Self {
        Self(
            type: .drop,
            color: color,
            offset: offset,
            blur: blur,
            spread: spread
        )
    }

    public static func inner(
        color: ColorValue?,
        offset: CGSize,
        radius: CGFloat,
        spread: CGFloat = .zero
    ) -> Self {
        Self(
            type: .inner,
            color: color,
            offset: offset,
            radius: radius,
            spread: spread
        )
    }

    public static func inner(
        color: ColorValue?,
        offset: CGSize,
        blur: CGFloat,
        spread: CGFloat = .zero
    ) -> Self {
        Self(
            type: .inner,
            color: color,
            offset: offset,
            blur: blur,
            spread: spread
        )
    }
}
