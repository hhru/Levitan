import Foundation

public typealias InterpolatingSpringAnimationToken = Token<InterpolatingSpringAnimation>

extension InterpolatingSpringAnimationToken {

    public init(
        mass: Double = 1.0,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double = .zero,
        duration: Double
    ) {
        self = Value(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            duration: duration
        ).token
    }
}
