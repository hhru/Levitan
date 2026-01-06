import SwiftUI

public struct OpacityModifier<Content: View>: Hashable, Sendable {

    public let opacity: OpacityToken?

    public init(opacity: OpacityToken?) {
        self.opacity = opacity
    }
}

extension OpacityModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let opacity = opacity?.resolve(for: theme) {
            content.opacity(opacity)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func opacity(
        _ opacity: OpacityToken?
    ) -> TokenModifiedView<OpacityModifier<Self>> {
        modifier(OpacityModifier(opacity: opacity))
    }
}
