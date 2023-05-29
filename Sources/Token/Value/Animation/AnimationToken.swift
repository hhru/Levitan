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
