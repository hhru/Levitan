import SwiftUI

internal struct ScaleEffectModifier<Content: View>: TokenViewModifier {

    internal let scaling: ScalingToken?
    internal let anchor: UnitPoint

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let scaling = scaling?.resolve(for: theme) {
            content.scaleEffect(scaling, anchor: anchor)
        } else {
            content
        }
    }
}

extension View {

    public func scaleEffect(
        _ scaling: ScalingToken?,
        anchor: UnitPoint = .center
    ) -> some View {
        modifier(
            ScaleEffectModifier(
                scaling: scaling,
                anchor: anchor
            )
        )
    }
}
