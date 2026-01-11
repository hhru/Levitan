import SwiftUI

public struct AccentColorModifier<Content: View>: Hashable, Sendable {

    public let color: ColorToken?

    public init(color: ColorToken?) {
        self.color = color
    }
}

extension AccentColorModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        content.accentColor(color?.color.resolve(for: theme))
    }
}

extension View {

    public nonisolated func accentColor(
        _ color: ColorToken?
    ) -> TokenModifiedView<AccentColorModifier<Self>> {
        modifier(AccentColorModifier(color: color))
    }
}
