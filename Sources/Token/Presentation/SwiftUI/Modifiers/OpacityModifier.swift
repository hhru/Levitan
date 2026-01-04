import SwiftUI

internal struct OpacityModifier<Content: View>: Hashable, Sendable {

    internal let opacity: OpacityToken?
}

extension OpacityModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let opacity = opacity?.resolve(for: theme) {
            content.opacity(opacity)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func opacity(_ opacity: OpacityToken?) -> some View {
        modifier(OpacityModifier(opacity: opacity))
    }
}
