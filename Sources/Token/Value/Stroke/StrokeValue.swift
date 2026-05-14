import SwiftUI

public struct StrokeValue:
    TokenValue,
    Changeable,
    Sendable {

    public let type: StrokeType

    public var width: CGFloat
    public var color: ColorValue

    public var insets: CGFloat {
        switch type {
        case .inside:
            .zero

        case .outside:
            -width

        case .center:
            -width * 0.5
        }
    }

    public var isZero: Bool {
        width <= .leastNonzeroMagnitude
    }

    public init(
        type: StrokeType,
        width: CGFloat,
        color: ColorValue = .black
    ) {
        self.type = type
        self.width = width
        self.color = color
    }
}

extension StrokeValue: DecorableByColor {

    public func color(_ color: ColorValue) -> Self {
        changing { $0.color = color }
    }
}

extension StrokeValue: Animatable {

    public var animatableData: AnimatablePair<CGFloat, ColorValue.AnimatableData> {
        get {
            AnimatablePair(
                width,
                color.animatableData
            )
        }

        set {
            width = newValue.first
            color.animatableData = newValue.second
        }
    }
}

extension StrokeValue {

    public static var zero: Self {
        .inside(width: .zero)
    }

    public static func inside(
        width: CGFloat,
        color: ColorValue = .black
    ) -> Self {
        Self(
            type: .inside,
            width: width,
            color: color
        )
    }

    public static func outside(
        width: CGFloat,
        color: ColorValue = .black
    ) -> Self {
        Self(
            type: .outside,
            width: width,
            color: color
        )
    }

    public static func center(
        width: CGFloat,
        color: ColorValue = .black
    ) -> Self {
        Self(
            type: .center,
            width: width,
            color: color
        )
    }
}
