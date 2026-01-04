import SwiftUI

internal struct PaddingModifier<Content: View>: Hashable, Sendable {

    internal let insets: InsetsToken?
}

extension PaddingModifier: TokenViewModifier {

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

    public nonisolated func padding(
        top: SpacingToken = .zero,
        leading: SpacingToken = .zero,
        bottom: SpacingToken = .zero,
        trailing: SpacingToken = .zero
    ) -> some View {
        padding(
            InsetsToken(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }

    public nonisolated func padding(_ edge: InsetsEdge, _ value: SpacingToken) -> some View {
        padding(InsetsToken(edge, value))
    }

    public nonisolated func padding(all spacing: SpacingToken?) -> some View {
        padding(spacing.map(InsetsToken.init(all:)))
    }
}
