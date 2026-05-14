import SwiftUI

public struct CornersValue:
    TokenValue,
    Changeable,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    Sendable {

    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat

    public var isRectangular: Bool {
        topLeft == .zero
            && topRight == .zero
            && bottomLeft == .zero
            && bottomRight == .zero
    }

    public init(
        topLeft: CGFloat = .zero,
        topRight: CGFloat = .zero,
        bottomLeft: CGFloat = .zero,
        bottomRight: CGFloat = .zero
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public init(
        radius: CGFloat,
        mask: CornersMask = .all
    ) {
        self.init(
            topLeft: mask.contains(.topLeft) ? radius : .zero,
            topRight: mask.contains(.topRight) ? radius : .zero,
            bottomLeft: mask.contains(.bottomLeft) ? radius : .zero,
            bottomRight: mask.contains(.bottomRight) ? radius : .zero
        )
    }

    public init(integerLiteral radius: Int) {
        self.init(radius: CGFloat(radius))
    }

    public init(floatLiteral radius: Double) {
        self.init(radius: CGFloat(radius))
    }
}

extension CornersValue: Animatable {

    public var animatableData: AnimatablePair<
        AnimatablePair<CGFloat, CGFloat>,
        AnimatablePair<CGFloat, CGFloat>
    > {
        get {
            AnimatablePair(
                AnimatablePair(topLeft, topRight),
                AnimatablePair(bottomLeft, bottomRight)
            )
        }

        set {
            topLeft = newValue.first.first
            topRight = newValue.first.second
            bottomLeft = newValue.second.first
            bottomRight = newValue.second.second
        }
    }
}

extension CornersValue {

    public static var rectangular: Self {
        rounded(radius: .zero)
    }

    public static func rounded(radius: CGFloat, mask: CornersMask = .all) -> Self {
        Self(radius: radius, mask: mask)
    }
}
