import SwiftUI

internal struct AccentColorModifier<Content: View>: Equatable, Sendable {

    internal let color: ColorToken?
}

extension AccentColorModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.accentColor(color?.color.resolve(for: theme))
    }
}

extension View {

    public nonisolated func accentColor(_ color: ColorToken?) -> some View {
        modifier(AccentColorModifier(color: color))
    }
}
