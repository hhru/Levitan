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
}

extension AnimationValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            controlPoint1: copy.controlPoint1,
            controlPoint2: copy.controlPoint2,
            duration: copy.duration
        )
    }

    public func duration(_ duration: Double) -> Self {
        changing { $0.duration = duration }
    }
}
