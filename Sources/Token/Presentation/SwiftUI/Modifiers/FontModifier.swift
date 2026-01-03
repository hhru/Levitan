#if canImport(UIKit)
import SwiftUI

internal struct FontModifier<Content: View>: Equatable, Sendable {

    internal let font: FontToken?
}

extension FontModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let font = font?.resolve(for: theme) {
            content.font(font.font)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func font(_ font: FontToken?) -> some View {
        modifier(FontModifier(font: font))
    }
}
#endif
