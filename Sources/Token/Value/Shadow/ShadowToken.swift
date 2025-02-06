import CoreGraphics

public typealias ShadowToken = Token<ShadowValue>

extension ShadowToken {

    public init(
        type: ShadowType,
        color: ColorToken?,
        offset: CGSize,
        radius: CGFloat,
        spread: CGFloat = .zero
    ) {
        self = Token(traits: [type, color, offset, radius, spread]) { theme in
            Value(
                type: type,
                color: color?.resolve(for: theme),
                offset: offset,
                radius: radius,
                spread: spread
            )
        }
    }

    public init(
        type: ShadowType,
        color: ColorToken?,
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

extension ShadowToken {

    public static var clear: Self {
        Self(
            type: .drop,
            color: nil,
            offset: .zero,
            radius: .zero
        )
    }

    public static func drop(
        color: ColorToken?,
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
        color: ColorToken?,
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
        color: ColorToken?,
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
        color: ColorToken?,
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
