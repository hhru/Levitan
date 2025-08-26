import SwiftUI

internal struct BackgroundGradientModifier<Content: View>: TokenViewModifier {

    internal let gradient: GradientToken?

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let gradient = gradient?.linearGradient.resolve(for: theme) {
            content.background(gradient)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func backgroundGradient(_ gradient: GradientToken?) -> some View {
        modifier(BackgroundGradientModifier(gradient: gradient))
    }
}
