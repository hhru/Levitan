import UIKit

public struct StrokeValue:
    TokenValue,
    DecorableByColor,
    Sendable {

    public let type: StrokeType
    public let width: CGFloat
    public let color: ColorValue?

    public var insets: CGFloat {
        switch type {
        case .inside:
            return .zero

        case .outside:
            return -width

        case .center:
            return -width * 0.5
        }
    }

    public var isZero: Bool {
        width <= .leastNonzeroMagnitude
    }

    public init(
        type: StrokeType,
        width: CGFloat,
        color: ColorValue? = nil
    ) {
        self.type = type
        self.width = width
        self.color = color
    }
}

extension StrokeValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            type: copy.type,
            width: copy.width,
            color: copy.color
        )
    }

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
        color: ColorValue? = nil
    ) -> Self {
        Self(
            type: .inside,
            width: width,
            color: color
        )
    }

    public static func outside(
        width: CGFloat,
        color: ColorValue? = nil
    ) -> Self {
        Self(
            type: .outside,
            width: width,
            color: color
        )
    }

    public static func center(
        width: CGFloat,
        color: ColorValue? = nil
    ) -> Self {
        Self(
            type: .center,
            width: width,
            color: color
        )
    }
}
