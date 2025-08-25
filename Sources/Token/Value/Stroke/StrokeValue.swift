import CoreGraphics
import SwiftUI

public struct StrokeValue:
    TokenValue,
    Changeable,
    Sendable {

    public var type: StrokeType
    public var width: CGFloat
    public var color: ColorValue?
    public var style: StrokeLineStyle

    public var insets: CGFloat {
        switch type {
        case .inside:
            return isDashed ? width * 0.5 : .zero

        case .outside:
            return isDashed ? -width * 0.5 : -width

        case .center:
            return isDashed ? .zero : -width * 0.5
        }
    }

    public var shapeInsets: CGFloat {
        guard !isDashed else {
            return .zero
        }

        switch type {
        case .inside:
            return .zero

        case .outside:
            return -width

        case .center:
            return -width * 0.5
        }
    }

    public var isDashed: Bool {
        !style.dash.isEmpty
    }

    public var isZero: Bool {
        width <= .leastNonzeroMagnitude
    }

    public init(
        type: StrokeType,
        width: CGFloat,
        color: ColorValue? = nil,
        style: StrokeLineStyle = .default
    ) {
        self.type = type
        self.width = width
        self.color = color
        self.style = style
    }
}

extension StrokeValue: DecorableByColor {

    public func color(_ color: ColorValue?) -> Self {
        changing { $0.color = color }
    }
}

extension StrokeValue {

    public static var zero: Self {
        .inside(width: .zero, color: nil)
    }

    public static func inside(
        width: CGFloat,
        color: ColorValue? = nil,
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
        width: CGFloat,
        color: ColorValue? = nil,
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
        width: CGFloat,
        color: ColorValue? = nil,
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
