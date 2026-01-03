#if canImport(UIKit)
import SwiftUI

extension ScaleEffectModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func scaleEffect(
        _ scaling: ScalingToken?,
        anchor: UnitPoint = .center
    ) -> some Component {
        modifier(
            ScaleEffectModifier(
                scaling: scaling,
                anchor: anchor
            )
        )
    }
}
#endif
