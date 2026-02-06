import SwiftUI

public struct ScaleEffectModifier<Content: View>: Hashable, Sendable {

    public let scaling: ScalingToken?
    public let anchor: UnitPoint

    public init(
        scaling: ScalingToken?,
        anchor: UnitPoint
    ) {
        self.scaling = scaling
        self.anchor = anchor
    }
}

extension ScaleEffectModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let scaling = scaling?.resolve(for: theme) {
            content.scaleEffect(scaling, anchor: anchor)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func scaleEffect(
        _ scaling: ScalingToken?,
        anchor: UnitPoint = .center
    ) -> TokenModifiedView<ScaleEffectModifier<Self>> {
        modifier(
            ScaleEffectModifier(
                scaling: scaling,
                anchor: anchor
            )
        )
    }
}
