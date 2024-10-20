import Foundation

public typealias AnimationToken = Token<AnimationValue>

extension AnimationToken {

    public init(
        controlPoint1: CGPoint,
        controlPoint2: CGPoint,
        duration: Double
    ) {
        self = Value(
            controlPoint1: controlPoint1,
            controlPoint2: controlPoint2,
            duration: duration
        ).token
    }
}

extension AnimationToken {

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
            controlPoint1: CGPoint(x: 0.42, y: 0.0),
            controlPoint2: CGPoint(x: 0.58, y: 1.0),
            duration: duration
        )
    }
}
