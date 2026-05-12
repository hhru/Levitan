import CoreGraphics
import SwiftUI

public protocol ShapeValue:
    TokenTraitProvider,
    Animatable,
    Hashable,
    Sendable where AnimatableData: Sendable {

    func path(size: CGSize, insets: CGFloat) -> CGPath
}
