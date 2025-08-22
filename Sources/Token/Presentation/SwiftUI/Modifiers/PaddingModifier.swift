import SwiftUI

internal struct PaddingModifier<Content: View>: TokenViewModifier {

    internal let insets: InsetsToken?

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let insets = insets?.resolve(for: theme) {
            content.padding(insets.edgeInsets)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func padding(_ insets: InsetsToken?) -> some View {
        modifier(PaddingModifier(insets: insets))
    }

    public nonisolated func padding(all spacing: SpacingToken?) -> some View {
        padding(spacing.map(InsetsToken.init(all:)))
    }
}
