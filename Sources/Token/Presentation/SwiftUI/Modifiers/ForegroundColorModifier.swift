import SwiftUI

internal struct ForegroundColorModifier<Content: View>: TokenViewModifier {

    internal let color: ColorToken?

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.foregroundColor(color?.resolve(for: theme).color)
    }
}

extension View {

    public nonisolated func foregroundColor(_ color: ColorToken?) -> some View {
        modifier(ForegroundColorModifier(color: color))
    }
}
