import SwiftUI

internal struct BackgroundColorModifier<Content: View>: Hashable, Sendable {

    internal let color: ColorToken?
}

extension BackgroundColorModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.background(color?.color.resolve(for: theme))
    }
}

extension View {

    public nonisolated func backgroundColor(_ color: ColorToken?) -> some View {
        modifier(BackgroundColorModifier(color: color))
    }
}
