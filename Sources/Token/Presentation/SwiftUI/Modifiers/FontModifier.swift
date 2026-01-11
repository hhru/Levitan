#if canImport(UIKit)
import SwiftUI

public struct FontModifier<Content: View>: Hashable, Sendable {

    public let font: FontToken?

    public init(font: FontToken?) {
        self.font = font
    }
}

extension FontModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let font = font?.resolve(for: theme) {
            content.font(font.font)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func font(
        _ font: FontToken?
    ) -> TokenModifiedView<FontModifier<Self>> {
        modifier(FontModifier(font: font))
    }
}
#endif
