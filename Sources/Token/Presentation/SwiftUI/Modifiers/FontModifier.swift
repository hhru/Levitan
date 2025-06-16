#if canImport(UIKit)
import SwiftUI

internal struct FontModifier<Content: View>: TokenViewModifier {

    internal let font: FontToken?

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let font = font?.resolve(for: theme) {
            content.font(font.font)
        } else {
            content
        }
    }
}

extension View {

    public func font(_ font: FontToken?) -> some View {
        modifier(FontModifier(font: font))
    }
}
#endif
