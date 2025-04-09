#if canImport(UIKit)
import UIKit
#endif

import SwiftUI
import QuartzCore

public struct AnimationValue:
    TokenValue,
    Changeable,
    Sendable {

    public var controlPoint1: CGPoint
    public var controlPoint2: CGPoint
    public var duration: Double

    public var caTransition: CATransition {
        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(
            controlPoints: Float(controlPoint1.x),
            Float(controlPoint1.y),
            Float(controlPoint2.x),
            Float(controlPoint2.y)
        )

        animation.type = CATransitionType.fade
        animation.duration = duration / 1000.0

        return animation
    }

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

    #if canImport(UIKit)
    public func propertyAnimator(animations: (() -> Void)? = nil) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(
            duration: duration,
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2,
            animations: animations
        )
    }
    #endif
}

extension AnimationValue: DecorableByDuration {

    public func duration(_ duration: Double) -> Self {
        changing { $0.duration = duration }
    }
}

extension AnimationValue {

    public static func linear(duration: Double) -> Self {
        Self(
            controlPoint1: .zero,
            controlPoint2: CGPoint(x: 1.0, y: 1.0),
            duration: duration
        )
    }

    public static func easeIn(duration: Double) -> Self {
        Self(
            controlPoint1: CGPoint(x: 0.42, y: .zero),
            controlPoint2: CGPoint(x: 1.0, y: 1.0),
            duration: duration
        )
    }

    public static func easeOut(duration: Double) -> Self {
        Self(
            controlPoint1: .zero,
            controlPoint2: CGPoint(x: 0.58, y: 1.0),
            duration: duration
        )
    }

    public static func easeInEaseOut(duration: Double) -> Self {
        Self(
            controlPoint1: CGPoint(x: 0.42, y: .zero),
            controlPoint2: CGPoint(x: 0.58, y: 1.0),
            duration: duration
        )
    }
}
