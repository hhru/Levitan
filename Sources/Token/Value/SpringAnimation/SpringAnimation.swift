import SwiftUI
import QuartzCore

public struct SpringAnimation:
    TokenValue,
    Changeable,
    Sendable {

    public var mass: Double
    public var stiffness: Double
    public var damping: Double
    public var initialVelocity: Double

    public var duration: Double

    private var caAnimation: CASpringAnimation {
        let caAnimation = CASpringAnimation(keyPath: "SpringAnimation.caAnimation")
        caAnimation.mass = mass
        caAnimation.damping = damping
        caAnimation.stiffness = stiffness
        caAnimation.duration = duration
        caAnimation.initialVelocity = initialVelocity

        return caAnimation
    }

    private var calculatedPerceptualDuration: Double {
        2 * Double.pi / sqrt(stiffness)
    }

    public var animation: Animation {
        .interpolatingSpring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        )
        .speed(calculatedPerceptualDuration / duration)
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
}
