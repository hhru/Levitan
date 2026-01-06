import SwiftUI

public struct BackgroundColorModifier<Content: View>: Hashable, Sendable {

    public let color: ColorToken?

    public init(color: ColorToken?) {
        self.color = color
    }
}

extension BackgroundColorModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        content.background(color?.color.resolve(for: theme))
    }
}

extension View {

    public nonisolated func backgroundColor(
        _ color: ColorToken?
    ) -> TokenModifiedView<BackgroundColorModifier<Self>> {
        modifier(BackgroundColorModifier(color: color))
    }
}
