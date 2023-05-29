import SwiftUI

internal struct AccentColorModifier<Content: View>: TokenViewModifier {

    internal let color: ColorToken?

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.accentColor(color?.color.resolve(for: theme))
    }
}

extension View {

    public func accentColor(_ color: ColorToken?) -> some View {
        modifier(AccentColorModifier(color: color))
    }
}
