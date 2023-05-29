import SwiftUI

public struct AnimationValue:
    TokenValue,
    DecorableByDuration,
    Sendable {

    public let controlPoint1: CGPoint
    public let controlPoint2: CGPoint
    public let duration: Double

    public var animation: Animation {
        .timingCurve(
            controlPoint1.x,
            controlPoint1.y,
            controlPoint2.x,
            controlPoint2.y,
            duration: duration
        )
    }

    public init(
        controlPoint1: CGPoint,
        controlPoint2: CGPoint,
        duration: Double
    ) {
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.duration = duration
    }

    public func propertyAnimator(animations: (() -> Void)? = nil) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(
            duration: duration,
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2,
            animations: animations
        )
    }

    public func duration(_ duration: Double) -> Self {
        Self(
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2,
            duration: duration
        )
    }
}
