import SwiftUI
import QuartzCore

public struct SpringAnimationValue:
    TokenValue,
    Changeable,
    Sendable {

    public var mass: Double
    public var stiffness: Double
    public var damping: Double
    public var initialVelocity: Double

    public var duration: Double

    public var animation: Animation {
        .interpolatingSpring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )
        .speed(2.0 * Double.pi / sqrt(stiffness) / duration)
    }

    public init(
        mass: Double,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double,
        duration: Double
    ) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
        self.initialVelocity = initialVelocity
        self.duration = duration
    }

    public func caAnimation(keyPath: String) -> CASpringAnimation {
        let caAnimation = CASpringAnimation(keyPath: keyPath)

        caAnimation.mass = mass
        caAnimation.stiffness = stiffness
        caAnimation.damping = damping
        caAnimation.duration = duration
        caAnimation.initialVelocity = initialVelocity

        return caAnimation
    }
}
