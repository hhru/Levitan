import SwiftUI

public struct RectangleAnimatableData: Equatable, Sendable {

    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat
}

extension RectangleAnimatableData: AdditiveArithmetic {

    public static var zero: Self {
        Self(
            topLeft: .zero,
            topRight: .zero,
            bottomLeft: .zero,
            bottomRight: .zero
        )
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(
            topLeft: lhs.topLeft + rhs.topLeft,
            topRight: lhs.topRight + rhs.topRight,
            bottomLeft: lhs.bottomLeft + rhs.bottomLeft,
            bottomRight: lhs.bottomRight + rhs.bottomRight
        )
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(
            topLeft: lhs.topLeft - rhs.topLeft,
            topRight: lhs.topRight - rhs.topRight,
            bottomLeft: lhs.bottomLeft - rhs.bottomLeft,
            bottomRight: lhs.bottomRight - rhs.bottomRight
        )
    }
}

extension RectangleAnimatableData: VectorArithmetic {

    public var magnitudeSquared: Double {
        topLeft.magnitudeSquared
            + topRight.magnitudeSquared
            + bottomLeft.magnitudeSquared
            + bottomRight.magnitudeSquared
    }

    public mutating func scale(by factor: Double) {
        topLeft.scale(by: factor)
        topRight.scale(by: factor)
        bottomLeft.scale(by: factor)
        bottomRight.scale(by: factor)
    }
}
