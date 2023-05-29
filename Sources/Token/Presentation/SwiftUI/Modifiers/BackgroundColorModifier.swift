import SwiftUI

internal struct BackgroundColorModifier<Content: View>: TokenViewModifier {

    internal let color: ColorToken?

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.background(color?.color.resolve(for: theme))
    }
}

extension View {

    public func backgroundColor(_ color: ColorToken?) -> some View {
        modifier(BackgroundColorModifier(color: color))
    }
}
