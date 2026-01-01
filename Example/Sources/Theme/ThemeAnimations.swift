import Foundation
import Levitan

struct ThemeAnimations: Sendable {

    let easeInOut100 = AnimationValue(
        controlPoint1: CGPoint(x: 0.25, y: 0.1),
        controlPoint2: CGPoint(x: 0.25, y: 1),
        duration: 0.1
    )

    let easeInOut200 = AnimationValue(
        controlPoint1: CGPoint(x: 0.25, y: 0.1),
        controlPoint2: CGPoint(x: 0.25, y: 1),
        duration: 0.2
    )
}
