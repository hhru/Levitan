import Foundation

public typealias StrokeToken = Token<StrokeValue>

extension StrokeToken {

    public init(
        type: StrokeType,
        width: StrokeWidthToken,
        color: ColorToken? = nil,
        style: StrokeLineStyle = .default
    ) {
        self = Token(traits: [type, width, color, style]) { theme in
            Value(
                type: type,
                width: width.resolve(for: theme),
                color: color?.resolve(for: theme),
                style: style
            )
        }
    }
}

extension StrokeToken {

    public static var zero: Self {
        .inside(width: .zero, color: nil)
    }

    public static func inside(
        width: StrokeWidthToken,
        color: ColorToken? = nil,
        style: StrokeLineStyle = .default
    ) -> Self {
        Self(
            type: .inside,
            width: width,
            color: color,
            style: style
        )
    }

    public static func outside(
        width: StrokeWidthToken,
        color: ColorToken? = nil,
        style: StrokeLineStyle = .default
    ) -> Self {
        Self(
            type: .outside,
            width: width,
            color: color,
            style: style
        )
    }

    public static func center(
        width: StrokeWidthToken,
        color: ColorToken? = nil,
        style: StrokeLineStyle = .default
    ) -> Self {
        Self(
            type: .center,
            width: width,
            color: color,
            style: style
        )
    }
}
